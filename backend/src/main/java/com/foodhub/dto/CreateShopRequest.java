package com.foodhub.dto;

import lombok.Data;

@Data
public class CreateShopRequest {
    private String name;
    private String description;
    private String address;
    private String phone;
    private Long shopOwnerId; // ID of existing shop owner user
    private String availability; // "OPEN" or "CLOSED"
}
