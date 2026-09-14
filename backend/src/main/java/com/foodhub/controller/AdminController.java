package com.foodhub.controller;

import com.foodhub.dto.*;
import com.foodhub.service.AdminService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin")
public class AdminController {

    private final AdminService adminService;

    public AdminController(AdminService adminService) {
        this.adminService = adminService;
    }

    // ======== DASHBOARD ========

    @GetMapping("/dashboard")
    public ResponseEntity<ApiResponse<DashboardStatsDTO>> getDashboard(
            @RequestHeader("X-User-Id") Long adminId) {
        return ResponseEntity.ok(ApiResponse.success(adminService.getDashboardStats(adminId)));
    }

    // ======== CUSTOMERS ========

    @GetMapping("/customers")
    public ResponseEntity<ApiResponse<List<UserDTO>>> getCustomers(
            @RequestHeader("X-User-Id") Long adminId,
            @RequestParam(required = false) String search) {
        List<UserDTO> customers = (search != null && !search.isBlank())
                ? adminService.searchCustomers(adminId, search)
                : adminService.getAllCustomers(adminId);
        return ResponseEntity.ok(ApiResponse.success(customers));
    }

    @GetMapping("/customers/{id}")
    public ResponseEntity<ApiResponse<UserDTO>> getCustomer(
            @RequestHeader("X-User-Id") Long adminId,
            @PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.success(adminService.getCustomerById(adminId, id)));
    }

    @PostMapping("/customers")
    public ResponseEntity<ApiResponse<UserDTO>> createCustomer(
            @RequestHeader("X-User-Id") Long adminId,
            @RequestBody CreateUserRequest request) {
        return ResponseEntity.ok(ApiResponse.success("Customer created", adminService.createCustomer(adminId, request)));
    }

    @PutMapping("/customers/{id}")
    public ResponseEntity<ApiResponse<UserDTO>> updateCustomer(
            @RequestHeader("X-User-Id") Long adminId,
            @PathVariable Long id,
            @RequestBody CreateUserRequest request) {
        return ResponseEntity.ok(ApiResponse.success("Customer updated", adminService.updateCustomer(adminId, id, request)));
    }

    @DeleteMapping("/customers/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteCustomer(
            @RequestHeader("X-User-Id") Long adminId,
            @PathVariable Long id) {
        adminService.deleteCustomer(adminId, id);
        return ResponseEntity.ok(ApiResponse.success("Customer deleted", null));
    }

    // ======== SHOP OWNERS ========

    @GetMapping("/shop-owners")
    public ResponseEntity<ApiResponse<List<UserDTO>>> getShopOwners(
            @RequestHeader("X-User-Id") Long adminId) {
        return ResponseEntity.ok(ApiResponse.success(adminService.getAllShopOwners(adminId)));
    }

    @PostMapping("/shop-owners")
    public ResponseEntity<ApiResponse<UserDTO>> createShopOwner(
            @RequestHeader("X-User-Id") Long adminId,
            @RequestBody CreateUserRequest request) {
        return ResponseEntity.ok(ApiResponse.success("Shop owner created", adminService.createShopOwner(adminId, request)));
    }

    // ======== SHOPS ========

    @GetMapping("/shops")
    public ResponseEntity<ApiResponse<List<ShopDTO>>> getShops(
            @RequestHeader("X-User-Id") Long adminId,
            @RequestParam(required = false) String search) {
        List<ShopDTO> shops = (search != null && !search.isBlank())
                ? adminService.searchShops(adminId, search)
                : adminService.getAllShops(adminId);
        return ResponseEntity.ok(ApiResponse.success(shops));
    }

    @GetMapping("/shops/{id}")
    public ResponseEntity<ApiResponse<ShopDTO>> getShop(
            @RequestHeader("X-User-Id") Long adminId,
            @PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.success(adminService.getShopById(adminId, id)));
    }

    @PostMapping("/shops")
    public ResponseEntity<ApiResponse<ShopDTO>> createShop(
            @RequestHeader("X-User-Id") Long adminId,
            @RequestBody CreateShopRequest request) {
        return ResponseEntity.ok(ApiResponse.success("Shop created", adminService.createShop(adminId, request)));
    }

    @PutMapping("/shops/{id}")
    public ResponseEntity<ApiResponse<ShopDTO>> updateShop(
            @RequestHeader("X-User-Id") Long adminId,
            @PathVariable Long id,
            @RequestBody CreateShopRequest request) {
        return ResponseEntity.ok(ApiResponse.success("Shop updated", adminService.updateShop(adminId, id, request)));
    }

    @DeleteMapping("/shops/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteShop(
            @RequestHeader("X-User-Id") Long adminId,
            @PathVariable Long id) {
        adminService.deleteShop(adminId, id);
        return ResponseEntity.ok(ApiResponse.success("Shop deleted", null));
    }
}
