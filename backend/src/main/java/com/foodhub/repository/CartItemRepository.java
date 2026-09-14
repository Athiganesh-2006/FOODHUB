package com.foodhub.repository;

import com.foodhub.entity.CartItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CartItemRepository extends JpaRepository<CartItem, Long> {
    Optional<CartItem> findByCartIdAndFoodId(Long cartId, Long foodId);
    java.util.List<CartItem> findByCartId(Long cartId);
    void deleteByCartId(Long cartId);
}
