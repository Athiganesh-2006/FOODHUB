package com.foodhub.repository;

import com.foodhub.entity.Shop;
import com.foodhub.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ShopRepository extends JpaRepository<Shop, Long> {
    List<Shop> findByShopOwner(User shopOwner);
    List<Shop> findByShopOwnerId(Long shopOwnerId);
    List<Shop> findByNameContainingIgnoreCase(String name);

    @Query("SELECT s FROM Shop s WHERE LOWER(s.name) LIKE LOWER(CONCAT('%', :query, '%')) " +
           "OR LOWER(s.description) LIKE LOWER(CONCAT('%', :query, '%'))")
    List<Shop> searchShops(@Param("query") String query);

    long count();
}
