package com.foodhub.service;

import com.foodhub.dto.*;
import com.foodhub.entity.*;
import com.foodhub.exception.ResourceNotFoundException;
import com.foodhub.exception.UnauthorizedException;
import com.foodhub.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class CustomerService {

    private final UserRepository userRepository;
    private final ShopRepository shopRepository;
    private final FoodRepository foodRepository;
    private final CartRepository cartRepository;
    private final CartItemRepository cartItemRepository;
    private final OrderRepository orderRepository;

    public CustomerService(UserRepository userRepository, ShopRepository shopRepository,
                           FoodRepository foodRepository, CartRepository cartRepository,
                           CartItemRepository cartItemRepository, OrderRepository orderRepository) {
        this.userRepository = userRepository;
        this.shopRepository = shopRepository;
        this.foodRepository = foodRepository;
        this.cartRepository = cartRepository;
        this.cartItemRepository = cartItemRepository;
        this.orderRepository = orderRepository;
    }

    private User verifyCustomer(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new UnauthorizedException("User not found"));
        if (user.getRole() != User.Role.CUSTOMER) {
            throw new UnauthorizedException("Access denied: Customer role required");
        }
        return user;
    }

    // ======== SHOP BROWSING ========

    public List<ShopDTO> getAllShops() {
        return shopRepository.findAll().stream()
                .map(s -> ShopDTO.fromEntity(s,
                        (int) foodRepository.countByShopIdAndAvailabilityTrue(s.getId())))
                .collect(Collectors.toList());
    }

    public ShopDTO getShopById(Long shopId) {
        Shop shop = shopRepository.findById(shopId)
                .orElseThrow(() -> new ResourceNotFoundException("Shop not found: " + shopId));
        return ShopDTO.fromEntity(shop,
                (int) foodRepository.countByShopIdAndAvailabilityTrue(shopId));
    }

    public List<FoodDTO> getShopFoods(Long shopId) {
        return foodRepository.findByShopIdAndAvailabilityTrue(shopId)
                .stream().map(FoodDTO::fromEntity).collect(Collectors.toList());
    }

    public List<FoodDTO> getFoodsByCategory(String category) {
        return foodRepository.findByCategory(category)
                .stream().map(FoodDTO::fromEntity).collect(Collectors.toList());
    }

    public SearchResultDTO search(String query) {
        List<ShopDTO> shops = shopRepository.searchShops(query)
                .stream().map(ShopDTO::fromEntity).collect(Collectors.toList());
        List<FoodDTO> foods = foodRepository.searchByName(query)
                .stream().map(FoodDTO::fromEntity).collect(Collectors.toList());

        // Match category names
        List<SearchResultDTO.CategoryResultDTO> categories = new ArrayList<>();
        for (Food.Category cat : Food.Category.values()) {
            if (cat.name().toLowerCase().contains(query.toLowerCase())) {
                long count = foodRepository.findByCategoryAndAvailabilityTrue(cat).size();
                categories.add(new SearchResultDTO.CategoryResultDTO(
                        cat.name().replace("_", " "), count));
            }
        }
        return new SearchResultDTO(shops, foods, categories);
    }

    // ======== CART ========

    private Cart getOrCreateCart(User customer) {
        return cartRepository.findByCustomer(customer).orElseGet(() -> {
            Cart cart = new Cart();
            cart.setCustomer(customer);
            return cartRepository.save(cart);
        });
    }

    public CartDTO getCart(Long customerId) {
        verifyCustomer(customerId);
        User customer = userRepository.findById(customerId).get();
        Cart cart = getOrCreateCart(customer);
        return buildCartDTO(cart);
    }

    @Transactional
    public CartDTO addToCart(Long customerId, AddToCartRequest request) {
        User customer = verifyCustomer(customerId);
        Food food = foodRepository.findById(request.getFoodId())
                .orElseThrow(() -> new ResourceNotFoundException("Food not found: " + request.getFoodId()));
        if (!food.getAvailability()) {
            throw new IllegalArgumentException("This food item is not available");
        }
        Cart cart = getOrCreateCart(customer);

        // Multi-shop cart: items from any number of shops may share one cart.
        // Each OrderItem carries its own shop, so checkout fans the order out
        // across shops without needing a single-shop cart.

        // Check if item already in cart
        Optional<CartItem> existing = cartItemRepository.findByCartIdAndFoodId(cart.getId(), food.getId());
        if (existing.isPresent()) {
            CartItem item = existing.get();
            item.setQuantity(item.getQuantity() + request.getQuantity());
            item.setUpdatedAt(java.time.LocalDateTime.now());
            cartItemRepository.save(item);
        } else {
            CartItem item = new CartItem();
            item.setCart(cart);
            item.setFood(food);
            item.setQuantity(request.getQuantity());
            item.setPrice(food.getPrice()); // price snapshot from DB
            cartItemRepository.save(item);
        }
        return buildCartDTO(cartRepository.findById(cart.getId()).get());
    }

    @Transactional
    public CartDTO updateCartItem(Long customerId, Long cartItemId, Integer quantity) {
        verifyCustomer(customerId);
        CartItem item = cartItemRepository.findById(cartItemId)
                .orElseThrow(() -> new ResourceNotFoundException("Cart item not found: " + cartItemId));
        // Security: ensure this cart belongs to the customer
        if (!item.getCart().getCustomer().getId().equals(customerId)) {
            throw new UnauthorizedException("This cart item does not belong to you");
        }
        if (quantity <= 0) {
            cartItemRepository.delete(item);
        } else {
            item.setQuantity(quantity);
            item.setUpdatedAt(java.time.LocalDateTime.now());
            cartItemRepository.save(item);
        }
        Cart cart = cartRepository.findByCustomerId(customerId).get();
        return buildCartDTO(cart);
    }

    @Transactional
    public CartDTO removeCartItem(Long customerId, Long cartItemId) {
        verifyCustomer(customerId);
        CartItem item = cartItemRepository.findById(cartItemId)
                .orElseThrow(() -> new ResourceNotFoundException("Cart item not found: " + cartItemId));
        if (!item.getCart().getCustomer().getId().equals(customerId)) {
            throw new UnauthorizedException("This cart item does not belong to you");
        }
        cartItemRepository.delete(item);
        Cart cart = cartRepository.findByCustomerId(customerId).get();
        return buildCartDTO(cart);
    }

    @Transactional
    public void clearCart(Long customerId) {
        verifyCustomer(customerId);
        cartRepository.findByCustomerId(customerId).ifPresent(cart -> {
            cart.getItems().clear();
            cartRepository.save(cart);
        });
    }

    // ======== CHECKOUT / ORDERS ========

    @Transactional
    public OrderDTO checkout(Long customerId, CheckoutRequest request) {
        User customer = verifyCustomer(customerId);
        Cart cart = cartRepository.findByCustomerId(customerId)
                .orElseThrow(() -> new ResourceNotFoundException("Cart is empty"));
        if (cart.getItems().isEmpty()) {
            throw new IllegalArgumentException("Cannot checkout with empty cart");
        }

        // Calculate total from DB prices (never trust frontend total)
        BigDecimal total = cart.getItems().stream()
                .map(item -> item.getPrice().multiply(BigDecimal.valueOf(item.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        // Estimated prep time = the longest single item in the order (initial rule).
        int estimatedPrep = cart.getItems().stream()
                .map(item -> item.getFood() != null && item.getFood().getPrepTimeMinutes() != null
                        ? item.getFood().getPrepTimeMinutes() : 15)
                .max(Integer::compareTo)
                .orElse(15);

        Order order = new Order();
        order.setCustomer(customer);
        order.setTotalAmount(total);
        order.setPaymentStatus(Order.PaymentStatus.SUCCESS); // dummy payment always succeeds
        order.setOrderStatus(Order.OrderStatus.PENDING);
        order.setFulfillmentStatus(Order.FulfillmentStatus.ORDER_PLACED);
        order.setEstimatedPrepMinutes(estimatedPrep);
        order.setPlacedAt(java.time.LocalDateTime.now());
        order = orderRepository.save(order);

        // Create order items
        for (CartItem cartItem : cart.getItems()) {
            OrderItem orderItem = new OrderItem();
            orderItem.setOrder(order);
            orderItem.setFood(cartItem.getFood());
            orderItem.setShop(cartItem.getFood().getShop());
            orderItem.setFoodName(cartItem.getFood().getName());
            orderItem.setQuantity(cartItem.getQuantity());
            orderItem.setPrice(cartItem.getPrice());
            orderItem.setItemStatus(Order.OrderStatus.PENDING);
            order.getItems().add(orderItem);
        }
        order = orderRepository.save(order);

        // Clear cart after successful checkout
        cart.getItems().clear();
        cartRepository.save(cart);

        return toOrderDTO(order);
    }

    public List<OrderDTO> getMyOrders(Long customerId) {
        verifyCustomer(customerId);
        return orderRepository.findByCustomerIdOrderByCreatedAtDesc(customerId)
                .stream().map(this::toOrderDTO).collect(Collectors.toList());
    }

    public OrderDTO getOrderById(Long customerId, Long orderId) {
        verifyCustomer(customerId);
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new ResourceNotFoundException("Order not found: " + orderId));
        if (!order.getCustomer().getId().equals(customerId)) {
            throw new UnauthorizedException("This order does not belong to you");
        }
        return toOrderDTO(order);
    }

    // ======== HELPERS ========

    private CartDTO buildCartDTO(Cart cart) {
        // Read the lines back from the DB rather than from cart.getItems().
        // Items are saved through cartItemRepository, so the Cart entity's own
        // collection is still stale within the same transaction — building from
        // it made the first add to an empty cart return zero items, and the UI
        // then looked like it needed a refresh to catch up.
        List<CartDTO.CartItemDTO> itemDTOs = cartItemRepository.findByCartId(cart.getId()).stream()
                .map(item -> new CartDTO.CartItemDTO(
                        item.getId(),
                        item.getFood().getId(),
                        item.getFood().getName(),
                        item.getFood().getShop().getId(),
                        item.getFood().getShop().getName(),
                        item.getQuantity(),
                        item.getPrice(),
                        item.getPrice().multiply(BigDecimal.valueOf(item.getQuantity())),
                        item.getFood().getImageUrl()
                )).collect(Collectors.toList());

        BigDecimal total = itemDTOs.stream()
                .map(CartDTO.CartItemDTO::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        return new CartDTO(cart.getId(), cart.getCustomer().getId(), itemDTOs, total);
    }

    private OrderDTO toOrderDTO(Order order) {
        return OrderDTO.fromEntity(order);
    }
}
