package com.foodhub.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ShopOwnerDashboardDTO {
    private long totalFoodItems;
    private long availableFoodItems;
    private long pendingOrders;
    private long acceptedOrders;
    private long rejectedOrders;
}
