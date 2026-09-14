package com.foodhub.dto;

import com.foodhub.entity.Cart;
import com.foodhub.entity.CartItem;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CartDTO {
    private Long cartId;
    private Long customerId;
    private List<CartItemDTO> items;
    private BigDecimal totalAmount;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class CartItemDTO {
        private Long cartItemId;
        private Long foodId;
        private String foodName;
        private Long shopId;
        private String shopName;
        private Integer quantity;
        private BigDecimal price;
        private BigDecimal subtotal;
        private String imageUrl;
    }
}
