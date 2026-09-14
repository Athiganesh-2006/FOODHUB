package com.foodhub.service;

import com.foodhub.dto.*;
import com.foodhub.entity.Shop;
import com.foodhub.entity.User;
import com.foodhub.exception.ResourceNotFoundException;
import com.foodhub.exception.UnauthorizedException;
import com.foodhub.repository.*;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class AdminService {

    private final UserRepository userRepository;
    private final ShopRepository shopRepository;
    private final OrderRepository orderRepository;
    private final PasswordEncoder passwordEncoder;

    public AdminService(UserRepository userRepository, ShopRepository shopRepository,
                        OrderRepository orderRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.shopRepository = shopRepository;
        this.orderRepository = orderRepository;
        this.passwordEncoder = passwordEncoder;
    }

    private void verifyAdmin(Long requesterId) {
        User requester = userRepository.findById(requesterId)
                .orElseThrow(() -> new UnauthorizedException("User not found"));
        if (requester.getRole() != User.Role.ADMIN) {
            throw new UnauthorizedException("Access denied: Admin role required");
        }
    }

    // ======== DASHBOARD ========

    public DashboardStatsDTO getDashboardStats(Long adminId) {
        verifyAdmin(adminId);
        return new DashboardStatsDTO(
                userRepository.countByRole(User.Role.CUSTOMER),
                shopRepository.count(),
                userRepository.countByRole(User.Role.SHOP_OWNER),
                orderRepository.count()
        );
    }

    // ======== CUSTOMER MANAGEMENT ========

    public List<UserDTO> getAllCustomers(Long adminId) {
        verifyAdmin(adminId);
        return userRepository.findByRole(User.Role.CUSTOMER)
                .stream().map(UserDTO::fromEntity).collect(Collectors.toList());
    }

    public List<UserDTO> searchCustomers(Long adminId, String query) {
        verifyAdmin(adminId);
        return userRepository
                .findByRoleAndNameContainingIgnoreCaseOrRoleAndEmailContainingIgnoreCase(
                        User.Role.CUSTOMER, query, User.Role.CUSTOMER, query)
                .stream().map(UserDTO::fromEntity).collect(Collectors.toList());
    }

    public UserDTO getCustomerById(Long adminId, Long customerId) {
        verifyAdmin(adminId);
        User customer = userRepository.findById(customerId)
                .orElseThrow(() -> new ResourceNotFoundException("Customer not found with id: " + customerId));
        return UserDTO.fromEntity(customer);
    }

    @Transactional
    public UserDTO createCustomer(Long adminId, CreateUserRequest request) {
        verifyAdmin(adminId);
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new IllegalArgumentException("Email already in use: " + request.getEmail());
        }
        User customer = new User();
        customer.setName(request.getName());
        customer.setEmail(request.getEmail());
        customer.setPassword(passwordEncoder.encode(request.getPassword()));
        customer.setPhone(request.getPhone());
        customer.setAddress(request.getAddress());
        customer.setRole(User.Role.CUSTOMER);
        return UserDTO.fromEntity(userRepository.save(customer));
    }

    @Transactional
    public UserDTO updateCustomer(Long adminId, Long customerId, CreateUserRequest request) {
        verifyAdmin(adminId);
        User customer = userRepository.findById(customerId)
                .orElseThrow(() -> new ResourceNotFoundException("Customer not found with id: " + customerId));
        customer.setName(request.getName());
        customer.setPhone(request.getPhone());
        customer.setAddress(request.getAddress());
        if (request.getPassword() != null && !request.getPassword().isBlank()) {
            customer.setPassword(passwordEncoder.encode(request.getPassword()));
        }
        return UserDTO.fromEntity(userRepository.save(customer));
    }

    @Transactional
    public void deleteCustomer(Long adminId, Long customerId) {
        verifyAdmin(adminId);
        User customer = userRepository.findById(customerId)
                .orElseThrow(() -> new ResourceNotFoundException("Customer not found with id: " + customerId));
        userRepository.delete(customer);
    }

    // ======== SHOP OWNER MANAGEMENT ========

    public List<UserDTO> getAllShopOwners(Long adminId) {
        verifyAdmin(adminId);
        return userRepository.findByRole(User.Role.SHOP_OWNER)
                .stream().map(UserDTO::fromEntity).collect(Collectors.toList());
    }

    @Transactional
    public UserDTO createShopOwner(Long adminId, CreateUserRequest request) {
        verifyAdmin(adminId);
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new IllegalArgumentException("Email already in use: " + request.getEmail());
        }
        User shopOwner = new User();
        shopOwner.setName(request.getName());
        shopOwner.setEmail(request.getEmail());
        shopOwner.setPassword(passwordEncoder.encode(request.getPassword()));
        shopOwner.setPhone(request.getPhone());
        shopOwner.setAddress(request.getAddress());
        shopOwner.setRole(User.Role.SHOP_OWNER);
        return UserDTO.fromEntity(userRepository.save(shopOwner));
    }

    // ======== SHOP MANAGEMENT ========

    public List<ShopDTO> getAllShops(Long adminId) {
        verifyAdmin(adminId);
        return shopRepository.findAll()
                .stream().map(ShopDTO::fromEntity).collect(Collectors.toList());
    }

    public List<ShopDTO> searchShops(Long adminId, String query) {
        verifyAdmin(adminId);
        return shopRepository.searchShops(query)
                .stream().map(ShopDTO::fromEntity).collect(Collectors.toList());
    }

    public ShopDTO getShopById(Long adminId, Long shopId) {
        verifyAdmin(adminId);
        Shop shop = shopRepository.findById(shopId)
                .orElseThrow(() -> new ResourceNotFoundException("Shop not found with id: " + shopId));
        return ShopDTO.fromEntity(shop);
    }

    @Transactional
    public ShopDTO createShop(Long adminId, CreateShopRequest request) {
        verifyAdmin(adminId);
        User shopOwner = userRepository.findById(request.getShopOwnerId())
                .orElseThrow(() -> new ResourceNotFoundException("Shop owner not found with id: " + request.getShopOwnerId()));
        if (shopOwner.getRole() != User.Role.SHOP_OWNER) {
            throw new IllegalArgumentException("The specified user is not a shop owner");
        }
        Shop shop = new Shop();
        shop.setName(request.getName());
        shop.setDescription(request.getDescription());
        shop.setAddress(request.getAddress());
        shop.setPhone(request.getPhone());
        shop.setShopOwner(shopOwner);
        shop.setAvailability(request.getAvailability() != null ?
                Shop.Availability.valueOf(request.getAvailability()) : Shop.Availability.OPEN);
        return ShopDTO.fromEntity(shopRepository.save(shop));
    }

    @Transactional
    public ShopDTO updateShop(Long adminId, Long shopId, CreateShopRequest request) {
        verifyAdmin(adminId);
        Shop shop = shopRepository.findById(shopId)
                .orElseThrow(() -> new ResourceNotFoundException("Shop not found with id: " + shopId));
        shop.setName(request.getName());
        shop.setDescription(request.getDescription());
        shop.setAddress(request.getAddress());
        shop.setPhone(request.getPhone());
        if (request.getAvailability() != null) {
            shop.setAvailability(Shop.Availability.valueOf(request.getAvailability()));
        }
        if (request.getShopOwnerId() != null) {
            User newOwner = userRepository.findById(request.getShopOwnerId())
                    .orElseThrow(() -> new ResourceNotFoundException("Shop owner not found"));
            shop.setShopOwner(newOwner);
        }
        return ShopDTO.fromEntity(shopRepository.save(shop));
    }

    @Transactional
    public void deleteShop(Long adminId, Long shopId) {
        verifyAdmin(adminId);
        Shop shop = shopRepository.findById(shopId)
                .orElseThrow(() -> new ResourceNotFoundException("Shop not found with id: " + shopId));
        shopRepository.delete(shop);
    }
}
