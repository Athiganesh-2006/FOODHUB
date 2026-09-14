package com.foodhub.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SearchResultDTO {
    private List<ShopDTO> shops;
    private List<FoodDTO> foods;
    private List<CategoryResultDTO> categories;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class CategoryResultDTO {
        private String name;
        private long count;
    }
}
