package com.foodhub.dto;

import lombok.Data;

@Data
public class AddToCartRequest {
    private Long foodId;
    private Integer quantity;
}
