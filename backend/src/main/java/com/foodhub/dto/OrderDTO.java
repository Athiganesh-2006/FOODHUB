package com.foodhub.dto;

import com.foodhub.entity.Order;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrderDTO {
    private Long id;
    private Long customerId;
    private String customerName;
    private BigDecimal totalAmount;
    private Order.PaymentStatus paymentStatus;
    private Order.OrderStatus orderStatus;
    private List<OrderItemDTO> items;
    private LocalDateTime createdAt;

    // ---- Order tracking ----
    private Order.FulfillmentStatus fulfillmentStatus;
    private Integer estimatedPrepMinutes;
    private LocalDateTime placedAt;
    private LocalDateTime preparingAt;
    private LocalDateTime readyAt;
    private LocalDateTime completedAt;
    /** placedAt/preparingAt + estimatedPrepMinutes — the "estimated ready" time shown to the customer. */
    private LocalDateTime estimatedReadyAt;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class OrderItemDTO {
        private Long id;
        private Long foodId;
        private Long shopId;
        private String shopName;
        private String foodName;
        private Integer quantity;
        private BigDecimal price;
        private Order.OrderStatus itemStatus;
    }

    public static OrderDTO fromEntity(Order order) {
        List<OrderItemDTO> itemDTOs = order.getItems().stream()
                .map(i -> new OrderItemDTO(
                        i.getId(),
                        i.getFood() != null ? i.getFood().getId() : null,
                        i.getShop() != null ? i.getShop().getId() : null,
                        i.getShop() != null ? i.getShop().getName() : null,
                        i.getFoodName(),
                        i.getQuantity(),
                        i.getPrice(),
                        i.getItemStatus()
                )).collect(Collectors.toList());

        LocalDateTime base = order.getPreparingAt() != null
                ? order.getPreparingAt()
                : (order.getPlacedAt() != null ? order.getPlacedAt() : order.getCreatedAt());
        LocalDateTime estimatedReadyAt = (base != null && order.getEstimatedPrepMinutes() != null)
                ? base.plusMinutes(order.getEstimatedPrepMinutes())
                : null;

        OrderDTO dto = new OrderDTO();
        dto.setId(order.getId());
        dto.setCustomerId(order.getCustomer().getId());
        dto.setCustomerName(order.getCustomer().getName());
        dto.setTotalAmount(order.getTotalAmount());
        dto.setPaymentStatus(order.getPaymentStatus());
        dto.setOrderStatus(order.getOrderStatus());
        dto.setItems(itemDTOs);
        dto.setCreatedAt(order.getCreatedAt());
        dto.setFulfillmentStatus(order.getFulfillmentStatus());
        dto.setEstimatedPrepMinutes(order.getEstimatedPrepMinutes());
        dto.setPlacedAt(order.getPlacedAt() != null ? order.getPlacedAt() : order.getCreatedAt());
        dto.setPreparingAt(order.getPreparingAt());
        dto.setReadyAt(order.getReadyAt());
        dto.setCompletedAt(order.getCompletedAt());
        dto.setEstimatedReadyAt(estimatedReadyAt);
        return dto;
    }
}
