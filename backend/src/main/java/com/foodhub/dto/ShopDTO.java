package com.foodhub.dto;

import com.foodhub.entity.Shop;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ShopDTO {
    private Long id;
    private String name;
    private String description;
    private String address;
    private String phone;
    private String imageUrl;
    private Long shopOwnerId;
    private String shopOwnerName;
    private String shopOwnerEmail;
    private Shop.Availability availability;
    /** Number of available food items in this shop (null when not requested). */
    private Integer foodItemCount;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static ShopDTO fromEntity(Shop shop) {
        return fromEntity(shop, null);
    }

    public static ShopDTO fromEntity(Shop shop, Integer foodItemCount) {
        ShopDTO dto = new ShopDTO();
        dto.setId(shop.getId());
        dto.setName(shop.getName());
        dto.setDescription(shop.getDescription());
        dto.setAddress(shop.getAddress());
        dto.setPhone(shop.getPhone());
        dto.setImageUrl(shop.getImageUrl());
        if (shop.getShopOwner() != null) {
            dto.setShopOwnerId(shop.getShopOwner().getId());
            dto.setShopOwnerName(shop.getShopOwner().getName());
            dto.setShopOwnerEmail(shop.getShopOwner().getEmail());
        }
        dto.setAvailability(shop.getAvailability());
        dto.setFoodItemCount(foodItemCount);
        dto.setCreatedAt(shop.getCreatedAt());
        dto.setUpdatedAt(shop.getUpdatedAt());
        return dto;
    }
}
