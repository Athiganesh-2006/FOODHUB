package com.foodhub.repository;

import com.foodhub.entity.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {
    List<Order> findByCustomerIdOrderByCreatedAtDesc(Long customerId);

    @Query("SELECT DISTINCT o FROM Order o JOIN o.items i WHERE i.shop.id = :shopId ORDER BY o.createdAt DESC")
    List<Order> findOrdersByShopId(@Param("shopId") Long shopId);

    @Query("SELECT DISTINCT o FROM Order o JOIN o.items i WHERE i.shop.id = :shopId AND o.orderStatus = :status ORDER BY o.createdAt DESC")
    List<Order> findOrdersByShopIdAndStatus(@Param("shopId") Long shopId, @Param("status") Order.OrderStatus status);

    long countByOrderStatus(Order.OrderStatus status);
}
