package com.foodhub.dto;

import com.foodhub.entity.Food;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class FoodDTO {
    private Long id;
    private Long shopId;
    private String shopName;
    private String shopAvailability;
    private String name;
    private String description;
    private BigDecimal price;
    private String category;
    private String imageUrl;
    private Boolean availability;
    private Integer prepTimeMinutes;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static FoodDTO fromEntity(Food food) {
        return new FoodDTO(
            food.getId(),
            food.getShop() != null ? food.getShop().getId() : null,
            food.getShop() != null ? food.getShop().getName() : null,
            food.getShop() != null ? food.getShop().getAvailability().name() : null,
            food.getName(),
            food.getDescription(),
            food.getPrice(),
            food.getCategory() != null ? food.getCategory().name() : null,
            food.getImageUrl(),
            food.getAvailability(),
            food.getPrepTimeMinutes(),
            food.getCreatedAt(),
            food.getUpdatedAt()
        );
    }
}
