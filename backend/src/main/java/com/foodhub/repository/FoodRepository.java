package com.foodhub.repository;

import com.foodhub.entity.Food;
import com.foodhub.entity.Shop;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FoodRepository extends JpaRepository<Food, Long> {
    List<Food> findByShop(Shop shop);
    List<Food> findByShopId(Long shopId);
    List<Food> findByShopIdAndAvailabilityTrue(Long shopId);
    List<Food> findByCategory(Food.Category category);
    List<Food> findByCategoryAndAvailabilityTrue(Food.Category category);

    @Query("SELECT f FROM Food f WHERE LOWER(f.name) LIKE LOWER(CONCAT('%', :query, '%')) " +
           "OR LOWER(f.description) LIKE LOWER(CONCAT('%', :query, '%'))")
    List<Food> searchByName(@Param("query") String query);

    @Query("SELECT f FROM Food f WHERE LOWER(f.category) LIKE LOWER(CONCAT('%', :category, '%')) " +
           "AND f.availability = true")
    List<Food> findByCategory(@Param("category") String category);

    long countByShopId(Long shopId);
    long countByShopIdAndAvailabilityTrue(Long shopId);
}
