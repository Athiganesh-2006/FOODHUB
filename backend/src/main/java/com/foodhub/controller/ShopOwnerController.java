package com.foodhub.controller;

import com.foodhub.dto.*;
import com.foodhub.service.ShopOwnerService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/shop-owner")
public class ShopOwnerController {

    private final ShopOwnerService shopOwnerService;

    public ShopOwnerController(ShopOwnerService shopOwnerService) {
        this.shopOwnerService = shopOwnerService;
    }

    // ======== DASHBOARD ========

    @GetMapping("/dashboard")
    public ResponseEntity<ApiResponse<ShopOwnerDashboardDTO>> getDashboard(
            @RequestHeader("X-User-Id") Long shopOwnerId) {
        return ResponseEntity.ok(ApiResponse.success(shopOwnerService.getDashboard(shopOwnerId)));
    }

    // ======== SHOP ========

    @GetMapping("/shop")
    public ResponseEntity<ApiResponse<ShopDTO>> getMyShop(
            @RequestHeader("X-User-Id") Long shopOwnerId) {
        return ResponseEntity.ok(ApiResponse.success(shopOwnerService.getMyShop(shopOwnerId)));
    }

    @PatchMapping("/shop/toggle")
    public ResponseEntity<ApiResponse<ShopDTO>> toggleShopAvailability(
            @RequestHeader("X-User-Id") Long shopOwnerId) {
        return ResponseEntity.ok(ApiResponse.success("Shop status updated",
                shopOwnerService.toggleShopAvailability(shopOwnerId)));
    }

    // ======== FOOD ========

    @GetMapping("/foods")
    public ResponseEntity<ApiResponse<List<FoodDTO>>> getFoods(
            @RequestHeader("X-User-Id") Long shopOwnerId) {
        return ResponseEntity.ok(ApiResponse.success(shopOwnerService.getMyFoods(shopOwnerId)));
    }

    @PostMapping("/foods")
    public ResponseEntity<ApiResponse<FoodDTO>> addFood(
            @RequestHeader("X-User-Id") Long shopOwnerId,
            @RequestBody CreateFoodRequest request) {
        return ResponseEntity.ok(ApiResponse.success("Food added", shopOwnerService.addFood(shopOwnerId, request)));
    }

    @PutMapping("/foods/{id}")
    public ResponseEntity<ApiResponse<FoodDTO>> updateFood(
            @RequestHeader("X-User-Id") Long shopOwnerId,
            @PathVariable Long id,
            @RequestBody CreateFoodRequest request) {
        return ResponseEntity.ok(ApiResponse.success("Food updated", shopOwnerService.updateFood(shopOwnerId, id, request)));
    }

    @PatchMapping("/foods/{id}/toggle")
    public ResponseEntity<ApiResponse<FoodDTO>> toggleFood(
            @RequestHeader("X-User-Id") Long shopOwnerId,
            @PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.success("Food availability toggled",
                shopOwnerService.toggleFoodAvailability(shopOwnerId, id)));
    }

    @DeleteMapping("/foods/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteFood(
            @RequestHeader("X-User-Id") Long shopOwnerId,
            @PathVariable Long id) {
        shopOwnerService.deleteFood(shopOwnerId, id);
        return ResponseEntity.ok(ApiResponse.success("Food deleted", null));
    }

    // ======== ORDERS ========

    @GetMapping("/orders")
    public ResponseEntity<ApiResponse<List<OrderDTO>>> getOrders(
            @RequestHeader("X-User-Id") Long shopOwnerId,
            @RequestParam(required = false) String status) {
        List<OrderDTO> orders = (status != null && !status.isBlank())
                ? shopOwnerService.getShopOrdersByStatus(shopOwnerId, status)
                : shopOwnerService.getShopOrders(shopOwnerId);
        return ResponseEntity.ok(ApiResponse.success(orders));
    }

    @PatchMapping("/orders/items/{itemId}/status")
    public ResponseEntity<ApiResponse<OrderDTO>> updateOrderItemStatus(
            @RequestHeader("X-User-Id") Long shopOwnerId,
            @PathVariable Long itemId,
            @RequestParam String status) {
        return ResponseEntity.ok(ApiResponse.success("Order status updated",
                shopOwnerService.updateOrderItemStatus(shopOwnerId, itemId, status)));
    }

    // Order tracking: ORDER_PLACED -> PREPARING -> READY_FOR_PICKUP -> COMPLETED
    @PatchMapping("/orders/{orderId}/fulfillment")
    public ResponseEntity<ApiResponse<OrderDTO>> updateOrderFulfillment(
            @RequestHeader("X-User-Id") Long shopOwnerId,
            @PathVariable Long orderId,
            @RequestParam String status) {
        return ResponseEntity.ok(ApiResponse.success("Order tracking updated",
                shopOwnerService.updateOrderFulfillment(shopOwnerId, orderId, status)));
    }
}
