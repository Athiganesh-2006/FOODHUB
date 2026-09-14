package com.foodhub.repository;

import com.foodhub.entity.OrderItem;
import com.foodhub.entity.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrderItemRepository extends JpaRepository<OrderItem, Long> {
    List<OrderItem> findByOrderId(Long orderId);
    List<OrderItem> findByShopId(Long shopId);
    List<OrderItem> findByShopIdAndItemStatus(Long shopId, Order.OrderStatus status);
    long countByShopIdAndItemStatus(Long shopId, Order.OrderStatus status);
}
