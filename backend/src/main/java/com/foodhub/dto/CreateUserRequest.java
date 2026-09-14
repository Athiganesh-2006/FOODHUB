package com.foodhub.dto;

import lombok.Data;

@Data
public class CreateUserRequest {
    private String name;
    private String email;
    private String password;
    private String phone;
    private String address;
    private String role; // "CUSTOMER" or "SHOP_OWNER"
}
