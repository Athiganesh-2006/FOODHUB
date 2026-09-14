package com.foodhub.service;

import com.foodhub.dto.*;
import com.foodhub.entity.*;
import com.foodhub.exception.ResourceNotFoundException;
import com.foodhub.exception.UnauthorizedException;
import com.foodhub.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ShopOwnerService {

    private final UserRepository userRepository;
    private final ShopRepository shopRepository;
    private final FoodRepository foodRepository;
    private final OrderRepository orderRepository;
    private final OrderItemRepository orderItemRepository;

    public ShopOwnerService(UserRepository userRepository, ShopRepository shopRepository,
                            FoodRepository foodRepository, OrderRepository orderRepository,
                            OrderItemRepository orderItemRepository) {
        this.userRepository = userRepository;
        this.shopRepository = shopRepository;
        this.foodRepository = foodRepository;
        this.orderRepository = orderRepository;
        this.orderItemRepository = orderItemRepository;
    }

    private User verifyShopOwner(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new UnauthorizedException("User not found"));
        if (user.getRole() != User.Role.SHOP_OWNER) {
            throw new UnauthorizedException("Access denied: Shop owner role required");
        }
        return user;
    }

    private Shop getOwnShop(Long shopOwnerId) {
        List<Shop> shops = shopRepository.findByShopOwnerId(shopOwnerId);
        if (shops.isEmpty()) {
            throw new ResourceNotFoundException("No shop found for this owner");
        }
        if (shops.size() > 1) {
            System.out.println("WARN: shop owner " + shopOwnerId + " has " + shops.size()
                    + " shops; using the first one for this session.");
        }
        return shops.get(0);
    }

    // ======== DASHBOARD ========

    public ShopOwnerDashboardDTO getDashboard(Long shopOwnerId) {
        verifyShopOwner(shopOwnerId);
        Shop shop = getOwnShop(shopOwnerId);
        long totalFood = foodRepository.countByShopId(shop.getId());
        long availableFood = foodRepository.countByShopIdAndAvailabilityTrue(shop.getId());
        long pending = orderItemRepository.countByShopIdAndItemStatus(shop.getId(), Order.OrderStatus.PENDING);
        long accepted = orderItemRepository.countByShopIdAndItemStatus(shop.getId(), Order.OrderStatus.ACCEPTED);
        long rejected = orderItemRepository.countByShopIdAndItemStatus(shop.getId(), Order.OrderStatus.REJECTED);
        return new ShopOwnerDashboardDTO(totalFood, availableFood, pending, accepted, rejected);
    }

    // ======== SHOP MANAGEMENT ========

    public ShopDTO getMyShop(Long shopOwnerId) {
        verifyShopOwner(shopOwnerId);
        return ShopDTO.fromEntity(getOwnShop(shopOwnerId));
    }

    @Transactional
    public ShopDTO toggleShopAvailability(Long shopOwnerId) {
        verifyShopOwner(shopOwnerId);
        Shop shop = getOwnShop(shopOwnerId);
        shop.setAvailability(shop.getAvailability() == Shop.Availability.OPEN
                ? Shop.Availability.CLOSED : Shop.Availability.OPEN);
        return ShopDTO.fromEntity(shopRepository.save(shop));
    }

    // ======== FOOD MANAGEMENT ========

    public List<FoodDTO> getMyFoods(Long shopOwnerId) {
        verifyShopOwner(shopOwnerId);
        Shop shop = getOwnShop(shopOwnerId);
        return foodRepository.findByShop(shop)
                .stream().map(FoodDTO::fromEntity).collect(Collectors.toList());
    }

    @Transactional
    public FoodDTO addFood(Long shopOwnerId, CreateFoodRequest request) {
        verifyShopOwner(shopOwnerId);
        Shop shop = getOwnShop(shopOwnerId);
        Food food = new Food();
        food.setShop(shop);
        food.setName(request.getName());
        food.setDescription(request.getDescription());
        food.setPrice(request.getPrice());
        food.setCategory(request.getCategory() != null ?
                Food.Category.valueOf(request.getCategory().toUpperCase().replace(" ", "_")) : null);
        food.setImageUrl(request.getImageUrl());
        food.setAvailability(request.getAvailability() != null ? request.getAvailability() : true);
        food.setPrepTimeMinutes(request.getPrepTimeMinutes() != null ? request.getPrepTimeMinutes() : 15);
        return FoodDTO.fromEntity(foodRepository.save(food));
    }

    @Transactional
    public FoodDTO updateFood(Long shopOwnerId, Long foodId, CreateFoodRequest request) {
        verifyShopOwner(shopOwnerId);
        Shop shop = getOwnShop(shopOwnerId);
        Food food = foodRepository.findById(foodId)
                .orElseThrow(() -> new ResourceNotFoundException("Food not found with id: " + foodId));
        // Security check: ensure food belongs to this owner's shop
        if (!food.getShop().getId().equals(shop.getId())) {
            throw new UnauthorizedException("You can only edit food items in your own shop");
        }
        food.setName(request.getName());
        food.setDescription(request.getDescription());
        food.setPrice(request.getPrice());
        food.setCategory(request.getCategory() != null ?
                Food.Category.valueOf(request.getCategory().toUpperCase().replace(" ", "_")) : null);
        food.setImageUrl(request.getImageUrl());
        if (request.getAvailability() != null) {
            food.setAvailability(request.getAvailability());
        }
        if (request.getPrepTimeMinutes() != null) {
            food.setPrepTimeMinutes(request.getPrepTimeMinutes());
        }
        return FoodDTO.fromEntity(foodRepository.save(food));
    }

    @Transactional
    public FoodDTO toggleFoodAvailability(Long shopOwnerId, Long foodId) {
        verifyShopOwner(shopOwnerId);
        Shop shop = getOwnShop(shopOwnerId);
        Food food = foodRepository.findById(foodId)
                .orElseThrow(() -> new ResourceNotFoundException("Food not found with id: " + foodId));
        if (!food.getShop().getId().equals(shop.getId())) {
            throw new UnauthorizedException("You can only modify food in your own shop");
        }
        food.setAvailability(!food.getAvailability());
        return FoodDTO.fromEntity(foodRepository.save(food));
    }

    @Transactional
    public void deleteFood(Long shopOwnerId, Long foodId) {
        verifyShopOwner(shopOwnerId);
        Shop shop = getOwnShop(shopOwnerId);
        Food food = foodRepository.findById(foodId)
                .orElseThrow(() -> new ResourceNotFoundException("Food not found with id: " + foodId));
        if (!food.getShop().getId().equals(shop.getId())) {
            throw new UnauthorizedException("You can only delete food in your own shop");
        }
        foodRepository.delete(food);
    }

    // ======== ORDER MANAGEMENT ========

    public List<OrderDTO> getShopOrders(Long shopOwnerId) {
        verifyShopOwner(shopOwnerId);
        Shop shop = getOwnShop(shopOwnerId);
        return orderRepository.findOrdersByShopId(shop.getId())
                .stream().map(o -> toOrderDTO(o, shop.getId())).collect(Collectors.toList());
    }

    public List<OrderDTO> getShopOrdersByStatus(Long shopOwnerId, String status) {
        verifyShopOwner(shopOwnerId);
        Shop shop = getOwnShop(shopOwnerId);
        Order.OrderStatus orderStatus = Order.OrderStatus.valueOf(status.toUpperCase());
        return orderRepository.findOrdersByShopIdAndStatus(shop.getId(), orderStatus)
                .stream().map(o -> toOrderDTO(o, shop.getId())).collect(Collectors.toList());
    }

    @Transactional
    public OrderDTO updateOrderItemStatus(Long shopOwnerId, Long orderItemId, String status) {
        verifyShopOwner(shopOwnerId);
        Shop shop = getOwnShop(shopOwnerId);
        OrderItem item = orderItemRepository.findById(orderItemId)
                .orElseThrow(() -> new ResourceNotFoundException("Order item not found: " + orderItemId));
        // Security check
        if (!item.getShop().getId().equals(shop.getId())) {
            throw new UnauthorizedException("You can only manage orders in your own shop");
        }
        Order.OrderStatus newStatus = Order.OrderStatus.valueOf(status.toUpperCase());
        item.setItemStatus(newStatus);
        orderItemRepository.save(item);

        // Update parent order status based on all items
        Order order = item.getOrder();
        boolean allAccepted = order.getItems().stream()
                .allMatch(i -> i.getItemStatus() == Order.OrderStatus.ACCEPTED);
        boolean anyRejected = order.getItems().stream()
                .anyMatch(i -> i.getItemStatus() == Order.OrderStatus.REJECTED);
        if (allAccepted) order.setOrderStatus(Order.OrderStatus.ACCEPTED);
        else if (anyRejected) order.setOrderStatus(Order.OrderStatus.REJECTED);

        return toOrderDTO(order, shop.getId());
    }

    // ======== ORDER TRACKING (fulfillment lifecycle) ========

    @Transactional
    public OrderDTO updateOrderFulfillment(Long shopOwnerId, Long orderId, String status) {
        verifyShopOwner(shopOwnerId);
        Shop shop = getOwnShop(shopOwnerId);
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new ResourceNotFoundException("Order not found: " + orderId));

        boolean ownsSomeItem = order.getItems().stream()
                .anyMatch(i -> i.getShop() != null && i.getShop().getId().equals(shop.getId()));
        if (!ownsSomeItem) {
            throw new UnauthorizedException("This order has no items from your shop");
        }

        Order.FulfillmentStatus target;
        try {
            target = Order.FulfillmentStatus.valueOf(status.toUpperCase().replace(" ", "_"));
        } catch (IllegalArgumentException ex) {
            throw new IllegalArgumentException("Unknown fulfillment status: " + status);
        }

        java.time.LocalDateTime now = java.time.LocalDateTime.now();
        if (order.getPlacedAt() == null) {
            order.setPlacedAt(order.getCreatedAt() != null ? order.getCreatedAt() : now);
        }
        // Stamp the timestamp for every stage up to and including the target,
        // so skipping a step still leaves a coherent timeline.
        switch (target) {
            case COMPLETED:
                if (order.getCompletedAt() == null) order.setCompletedAt(now);
                order.setOrderStatus(Order.OrderStatus.COMPLETED);
                // fall through
            case READY_FOR_PICKUP:
                if (order.getReadyAt() == null) order.setReadyAt(now);
                // fall through
            case PREPARING:
                if (order.getPreparingAt() == null) order.setPreparingAt(now);
                break;
            case ORDER_PLACED:
            default:
                break;
        }
        order.setFulfillmentStatus(target);
        return toOrderDTO(orderRepository.save(order), shop.getId());
    }

    private OrderDTO toOrderDTO(Order order) {
        return OrderDTO.fromEntity(order);
    }

    /**
     * Shop-scoped view of an order. Carts may now span several shops, so an
     * owner must only ever see the lines that belong to their own shop, with a
     * total covering just those lines rather than the whole customer order.
     */
    private OrderDTO toOrderDTO(Order order, Long shopId) {
        OrderDTO dto = OrderDTO.fromEntity(order);
        List<OrderDTO.OrderItemDTO> mine = dto.getItems().stream()
                .filter(i -> shopId.equals(i.getShopId()))
                .collect(Collectors.toList());
        dto.setItems(mine);
        dto.setTotalAmount(mine.stream()
                .map(i -> i.getPrice().multiply(java.math.BigDecimal.valueOf(i.getQuantity())))
                .reduce(java.math.BigDecimal.ZERO, java.math.BigDecimal::add));
        return dto;
    }
}
