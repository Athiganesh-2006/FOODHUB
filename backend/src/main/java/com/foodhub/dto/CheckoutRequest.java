package com.foodhub.dto;

import lombok.Data;

@Data
public class CheckoutRequest {
    private Long customerId;
    private String paymentMethod; // "DUMMY_CARD" or "CASH_ON_DELIVERY"
}
