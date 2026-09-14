package com.foodhub.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "orders")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id", nullable = false)
    private User customer;

    @Column(name = "total_amount", nullable = false, precision = 10, scale = 2)
    private BigDecimal totalAmount;

    @Enumerated(EnumType.STRING)
    @Column(name = "payment_status", nullable = false)
    private PaymentStatus paymentStatus = PaymentStatus.PENDING;

    @Enumerated(EnumType.STRING)
    @Column(name = "order_status", nullable = false)
    private OrderStatus orderStatus = OrderStatus.PENDING;

    // ---- Fulfillment / order tracking (additive; independent of orderStatus) ----

    @Enumerated(EnumType.STRING)
    @Column(name = "fulfillment_status", nullable = false)
    @ColumnDefault("'ORDER_PLACED'")
    private FulfillmentStatus fulfillmentStatus = FulfillmentStatus.ORDER_PLACED;

    /** Estimated preparation duration for the whole order (minutes). */
    @Column(name = "estimated_prep_minutes")
    private Integer estimatedPrepMinutes;

    /** Actual timestamp of each fulfillment transition. */
    @Column(name = "placed_at")
    private LocalDateTime placedAt;

    @Column(name = "preparing_at")
    private LocalDateTime preparingAt;

    @Column(name = "ready_at")
    private LocalDateTime readyAt;

    @Column(name = "completed_at")
    private LocalDateTime completedAt;

    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<OrderItem> items = new ArrayList<>();

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    public enum PaymentStatus {
        PENDING, SUCCESS, FAILED
    }

    public enum OrderStatus {
        PENDING, ACCEPTED, REJECTED, COMPLETED
    }

    /** Customer-facing pickup lifecycle, driven by the shop owner. */
    public enum FulfillmentStatus {
        ORDER_PLACED, PREPARING, READY_FOR_PICKUP, COMPLETED
    }
}
