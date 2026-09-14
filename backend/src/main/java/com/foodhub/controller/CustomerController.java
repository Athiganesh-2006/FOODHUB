package com.foodhub.controller;

import com.foodhub.dto.*;
import com.foodhub.service.CustomerService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/customer")
public class CustomerController {

    private final CustomerService customerService;

    public CustomerController(CustomerService customerService) {
        this.customerService = customerService;
    }

    // ======== SHOPS (public browsing) ========

    @GetMapping("/shops")
    public ResponseEntity<ApiResponse<List<ShopDTO>>> getAllShops() {
        return ResponseEntity.ok(ApiResponse.success(customerService.getAllShops()));
    }

    @GetMapping("/shops/{id}")
    public ResponseEntity<ApiResponse<ShopDTO>> getShop(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.success(customerService.getShopById(id)));
    }

    @GetMapping("/shops/{id}/foods")
    public ResponseEntity<ApiResponse<List<FoodDTO>>> getShopFoods(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.success(customerService.getShopFoods(id)));
    }

    @GetMapping("/foods/category")
    public ResponseEntity<ApiResponse<List<FoodDTO>>> getFoodsByCategory(
            @RequestParam String category) {
        return ResponseEntity.ok(ApiResponse.success(customerService.getFoodsByCategory(category)));
    }

    @GetMapping("/search")
    public ResponseEntity<ApiResponse<SearchResultDTO>> search(@RequestParam String query) {
        return ResponseEntity.ok(ApiResponse.success(customerService.search(query)));
    }

    // ======== CART ========

    @GetMapping("/cart")
    public ResponseEntity<ApiResponse<CartDTO>> getCart(
            @RequestHeader("X-User-Id") Long customerId) {
        return ResponseEntity.ok(ApiResponse.success(customerService.getCart(customerId)));
    }

    @PostMapping("/cart")
    public ResponseEntity<ApiResponse<CartDTO>> addToCart(
            @RequestHeader("X-User-Id") Long customerId,
            @RequestBody AddToCartRequest request) {
        return ResponseEntity.ok(ApiResponse.success("Added to cart",
                customerService.addToCart(customerId, request)));
    }

    @PutMapping("/cart/items/{itemId}")
    public ResponseEntity<ApiResponse<CartDTO>> updateCartItem(
            @RequestHeader("X-User-Id") Long customerId,
            @PathVariable Long itemId,
            @RequestParam Integer quantity) {
        return ResponseEntity.ok(ApiResponse.success("Cart updated",
                customerService.updateCartItem(customerId, itemId, quantity)));
    }

    @DeleteMapping("/cart/items/{itemId}")
    public ResponseEntity<ApiResponse<CartDTO>> removeCartItem(
            @RequestHeader("X-User-Id") Long customerId,
            @PathVariable Long itemId) {
        return ResponseEntity.ok(ApiResponse.success("Item removed",
                customerService.removeCartItem(customerId, itemId)));
    }

    @DeleteMapping("/cart/clear")
    public ResponseEntity<ApiResponse<Void>> clearCart(
            @RequestHeader("X-User-Id") Long customerId) {
        customerService.clearCart(customerId);
        return ResponseEntity.ok(ApiResponse.success("Cart cleared", null));
    }

    // ======== ORDERS ========

    @PostMapping("/checkout")
    public ResponseEntity<ApiResponse<OrderDTO>> checkout(
            @RequestHeader("X-User-Id") Long customerId,
            @RequestBody CheckoutRequest request) {
        request.setCustomerId(customerId);
        return ResponseEntity.ok(ApiResponse.success("Order placed successfully",
                customerService.checkout(customerId, request)));
    }

    @GetMapping("/orders")
    public ResponseEntity<ApiResponse<List<OrderDTO>>> getMyOrders(
            @RequestHeader("X-User-Id") Long customerId) {
        return ResponseEntity.ok(ApiResponse.success(customerService.getMyOrders(customerId)));
    }

    @GetMapping("/orders/{id}")
    public ResponseEntity<ApiResponse<OrderDTO>> getOrder(
            @RequestHeader("X-User-Id") Long customerId,
            @PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.success(customerService.getOrderById(customerId, id)));
    }
}
