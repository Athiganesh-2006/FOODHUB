package com.foodhub;

import com.foodhub.entity.Food;
import com.foodhub.entity.Order;
import com.foodhub.entity.Shop;
import com.foodhub.entity.User;
import com.foodhub.repository.FoodRepository;
import com.foodhub.repository.OrderRepository;
import com.foodhub.repository.ShopRepository;
import com.foodhub.repository.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

/**
 * Idempotent startup seeding. Safe to run on every boot:
 *  - users keyed by email
 *  - shops keyed by their owner (1 shop per owner)
 *  - foods keyed by (shop, name)
 * Nothing is duplicated or deleted on restart.
 */
@Component
public class DatabaseSeeder implements CommandLineRunner {

    private final UserRepository userRepository;
    private final ShopRepository shopRepository;
    private final FoodRepository foodRepository;
    private final OrderRepository orderRepository;
    private final PasswordEncoder passwordEncoder;

    public DatabaseSeeder(UserRepository userRepository, ShopRepository shopRepository,
                          FoodRepository foodRepository, OrderRepository orderRepository,
                          PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.shopRepository = shopRepository;
        this.foodRepository = foodRepository;
        this.orderRepository = orderRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    @Transactional
    public void run(String... args) {
        seedCoreUsers();
        seedShopsAndMenus();
        repairFoodRows();
        backfillOrderTracking();
    }

    // ------------------------------------------------------------------
    // Core users (unchanged behaviour + kept credentials)
    // ------------------------------------------------------------------
    private void seedCoreUsers() {
        ensureUser("admin@foodhub.com", "admin123", "Admin", "9999999999", "Q-Free HQ", User.Role.ADMIN);
        ensureUser("owner@foodhub.com", "owner123", "Shop Owner 1", "8888888888", "123 Main Street", User.Role.SHOP_OWNER);
        ensureUser("customer@foodhub.com", "customer123", "Test Customer", "7777777777", "456 Oak Avenue", User.Role.CUSTOMER);
    }

    private User ensureUser(String email, String rawPassword, String name,
                            String phone, String address, User.Role role) {
        return userRepository.findByEmail(email).orElseGet(() -> {
            User u = new User();
            u.setName(name);
            u.setEmail(email);
            u.setPassword(passwordEncoder.encode(rawPassword));
            u.setPhone(phone);
            u.setAddress(address);
            u.setRole(role);
            System.out.println("SEEDER: created user " + email + " (" + role + ")");
            return userRepository.save(u);
        });
    }

    // ------------------------------------------------------------------
    // Multi-shop catalogue
    // ------------------------------------------------------------------
    private record MenuItem(String name, String description, String category, double price, int prepMinutes) {}

    private record ShopDef(String ownerEmail, String ownerName, String shopName,
                           String description, String address, String phone,
                           List<MenuItem> menu) {}

    private static final List<ShopDef> SHOPS = List.of(
        new ShopDef(
            "owner@foodhub.com", "Shop Owner 1",
            "Q-Free Central Cafe",
            "The main campus cafe - tiffin, meals, biryani, snacks and beverages under one roof.",
            "Q-Free Campus, Block A, Ground Floor", "9876500001",
            List.of(
                new MenuItem("Idli", "Two steamed rice-and-lentil cakes with sambar and coconut chutney", "BREAKFAST", 30, 10),
                new MenuItem("Medu Vada", "Two crisp golden urad-dal fritters with sambar and chutney", "BREAKFAST", 35, 10),
                new MenuItem("Plain Dosa", "Thin crisp rice-and-lentil crepe with sambar and chutney", "BREAKFAST", 50, 10),
                new MenuItem("Masala Dosa", "Crisp dosa wrapped around spiced potato masala", "BREAKFAST", 70, 15),
                new MenuItem("Ghee Roast Dosa", "Extra-long dosa roasted in ghee until deep golden", "BREAKFAST", 90, 15),
                new MenuItem("Rava Dosa", "Lacy semolina dosa with onion, chilli and curry leaves", "BREAKFAST", 80, 15),
                new MenuItem("Ven Pongal", "Rice-and-moong-dal pongal tempered with pepper, cumin and cashew", "BREAKFAST", 45, 12),
                new MenuItem("Poori Masala", "Two fluffy pooris with potato masala", "BREAKFAST", 55, 12),
                new MenuItem("Idiyappam with Kurma", "Soft string hoppers with vegetable kurma", "BREAKFAST", 60, 12),
                new MenuItem("South Indian Veg Meals", "Rice with sambar, rasam, kootu, poriyal, curd, pickle and appalam", "LUNCH", 120, 15),
                new MenuItem("Curd Rice", "Rice folded with curd, tempered with mustard and curry leaf", "LUNCH", 50, 8),
                new MenuItem("Lemon Rice", "Tangy turmeric rice with peanuts and curry leaves", "LUNCH", 55, 10),
                new MenuItem("Tamarind Rice", "Puliyodarai - spiced tamarind rice with roasted peanuts", "LUNCH", 55, 10),
                new MenuItem("Sambar Rice", "One-pot rice cooked with lentils and mixed vegetables", "LUNCH", 70, 15),
                new MenuItem("Parotta with Salna", "Two layered flaky parottas with spicy salna gravy", "DINNER", 70, 15),
                new MenuItem("Veg Kurma Parotta", "Two parottas with rich mixed-vegetable kurma", "DINNER", 95, 18),
                new MenuItem("Veg Biryani", "Fragrant seeraga samba rice with vegetables and whole spices", "LUNCH", 130, 20),
                new MenuItem("Chicken Biryani", "Seeraga samba biryani with marinated chicken and a boiled egg", "LUNCH", 180, 25),
                new MenuItem("Egg Biryani", "Spiced biryani with two boiled eggs", "LUNCH", 140, 22),
                new MenuItem("Chicken 65", "Crisp fried chicken tossed with curry leaves, garlic and red chilli", "SNACKS", 150, 18),
                new MenuItem("Gobi 65", "Crisp cauliflower florets in a tangy chilli toss", "SNACKS", 110, 16),
                new MenuItem("Onion Samosa", "Three mini crisp samosas filled with spiced onion", "SNACKS", 30, 8),
                new MenuItem("Masala Chai", "Strong South-Indian style spiced tea", "BEVERAGES", 15, 5),
                new MenuItem("Filter Coffee", "Traditional degree coffee, frothy and strong", "BEVERAGES", 20, 5),
                new MenuItem("Spiced Buttermilk", "Neer moru with ginger, green chilli and curry leaf", "BEVERAGES", 20, 4),
                new MenuItem("Semiya Payasam", "Warm vermicelli-and-milk kheer with cashew and raisin", "DESSERTS", 40, 8)
            )
        ),
        new ShopDef(
            "southindian@qfree.com", "S. Ramesh",
            "Q-Free South Indian Kitchen",
            "Classic tiffin counter - dosa, idli, pongal and filter coffee made fresh through the day.",
            "Q-Free Campus, Block B, Level 1", "9876500002",
            List.of(
                new MenuItem("Idli", "Two steamed rice-and-lentil cakes with sambar and coconut chutney", "BREAKFAST", 30, 10),
                new MenuItem("Medu Vada", "Two crisp golden urad-dal fritters with sambar and chutney", "BREAKFAST", 35, 10),
                new MenuItem("Plain Dosa", "Thin crisp rice-and-lentil crepe with sambar and chutney", "BREAKFAST", 50, 10),
                new MenuItem("Masala Dosa", "Crisp dosa wrapped around spiced potato masala", "BREAKFAST", 70, 15),
                new MenuItem("Ghee Roast Dosa", "Extra-long dosa roasted in ghee until deep golden", "BREAKFAST", 90, 15),
                new MenuItem("Rava Dosa", "Lacy semolina dosa with onion, chilli and curry leaves", "BREAKFAST", 80, 15),
                new MenuItem("Ven Pongal", "Rice-and-moong-dal pongal tempered with pepper, cumin and cashew", "BREAKFAST", 45, 12),
                new MenuItem("Poori Masala", "Two fluffy pooris with potato masala", "BREAKFAST", 55, 12),
                new MenuItem("Filter Coffee", "Traditional degree coffee, frothy and strong", "BEVERAGES", 20, 5)
            )
        ),
        new ShopDef(
            "biryani@qfree.com", "K. Imran",
            "Q-Free Biryani House",
            "Dum biryani specialists - chicken, mutton, egg, paneer and veg, with fried starters.",
            "Q-Free Campus, Food Court, Stall 3", "9876500003",
            List.of(
                new MenuItem("Chicken Biryani", "Seeraga samba biryani with marinated chicken and a boiled egg", "LUNCH", 180, 25),
                new MenuItem("Mutton Biryani", "Slow-cooked mutton dum biryani with fried onion and mint", "LUNCH", 240, 30),
                new MenuItem("Veg Biryani", "Fragrant seeraga samba rice with vegetables and whole spices", "LUNCH", 130, 20),
                new MenuItem("Egg Biryani", "Spiced biryani with two boiled eggs", "LUNCH", 140, 22),
                new MenuItem("Paneer Biryani", "Biryani layered with cubes of spiced paneer", "LUNCH", 170, 22),
                new MenuItem("Chicken 65", "Crisp fried chicken tossed with curry leaves, garlic and red chilli", "SNACKS", 150, 18),
                new MenuItem("Gobi 65", "Crisp cauliflower florets in a tangy chilli toss", "SNACKS", 110, 16),
                new MenuItem("Bread Halwa", "Rich ghee-roasted bread halwa topped with nuts", "DESSERTS", 60, 10)
            )
        ),
        new ShopDef(
            "snacks@qfree.com", "M. Latha",
            "Q-Free Express Snacks",
            "Quick bites between classes - samosa, puffs, rolls, sandwiches, fries, tea and coffee.",
            "Q-Free Campus, Near Library Entrance", "9876500004",
            List.of(
                new MenuItem("Samosa", "Two crisp pastry triangles with a spiced potato-pea filling", "SNACKS", 20, 8),
                new MenuItem("Puffs", "Flaky baked puff pastry with a spiced vegetable filling", "SNACKS", 25, 8),
                new MenuItem("Veg Sandwich", "Grilled sandwich with vegetables and mint chutney", "SNACKS", 50, 7),
                new MenuItem("French Fries", "Crisp salted potato fries", "FAST_FOOD", 80, 10),
                new MenuItem("Veg Roll", "Kathi roll with spiced vegetables and onion", "SNACKS", 60, 10),
                new MenuItem("Chicken Roll", "Kathi roll with spiced chicken and onion", "SNACKS", 90, 12),
                new MenuItem("Tea", "Hot milk tea", "BEVERAGES", 12, 5),
                new MenuItem("Coffee", "Hot milk coffee", "BEVERAGES", 15, 5)
            )
        ),
        new ShopDef(
            "veg@qfree.com", "R. Priya",
            "Q-Free Veg Corner",
            "Pure-veg North Indian and Indo-Chinese - curries, fried rice, breads and full meals.",
            "Q-Free Campus, Block C, Ground Floor", "9876500005",
            List.of(
                new MenuItem("Paneer Butter Masala", "Paneer cubes in a rich tomato-butter gravy", "DINNER", 160, 20),
                new MenuItem("Veg Fried Rice", "Wok-tossed rice with mixed vegetables and soy", "LUNCH", 110, 15),
                new MenuItem("Gobi Manchurian", "Fried cauliflower in a tangy Indo-Chinese sauce", "SNACKS", 120, 16),
                new MenuItem("Paneer Fried Rice", "Fried rice tossed with cubes of paneer", "LUNCH", 140, 16),
                new MenuItem("Chapati", "Two soft whole-wheat chapatis", "DINNER", 25, 8),
                new MenuItem("Parotta", "Two layered flaky parottas", "DINNER", 25, 12),
                new MenuItem("Veg Meals", "Rice, chapati, dal, two curries, curd, pickle and papad", "LUNCH", 120, 15),
                new MenuItem("Dal Tadka", "Yellow dal tempered with cumin, garlic and ghee", "DINNER", 90, 15),
                new MenuItem("Jeera Rice", "Basmati rice tempered with cumin", "LUNCH", 80, 12)
            )
        )
    );

    private void seedShopsAndMenus() {
        int shopsTouched = 0, foodsAdded = 0;
        for (ShopDef def : SHOPS) {
            User owner = ensureUser(def.ownerEmail(), "owner123", def.ownerName(),
                    "9000000000", "Q-Free Campus", User.Role.SHOP_OWNER);

            String imageUrl = "/images/shops/" + slug(def.shopName()) + ".svg";
            List<Shop> existingShops = shopRepository.findByShopOwnerId(owner.getId());
            Shop shop = existingShops.isEmpty() ? new Shop() : existingShops.get(0);
            if (existingShops.size() > 1) {
                System.out.println("SEEDER: owner " + owner.getEmail() + " already has "
                        + existingShops.size() + " shops; reusing the first one.");
            }
            shop.setName(def.shopName());
            shop.setDescription(def.description());
            shop.setAddress(def.address());
            shop.setPhone(def.phone());
            shop.setImageUrl(imageUrl);
            shop.setShopOwner(owner);
            if (shop.getAvailability() == null) shop.setAvailability(Shop.Availability.OPEN);
            shop = shopRepository.save(shop);
            shopsTouched++;

            List<Food> existing = foodRepository.findByShopId(shop.getId());
            for (MenuItem mi : def.menu()) {
                boolean present = existing.stream()
                        .anyMatch(f -> f.getName().equalsIgnoreCase(mi.name()));
                if (present) continue;
                Food f = new Food();
                f.setShop(shop);
                f.setName(mi.name());
                f.setDescription(mi.description());
                f.setPrice(BigDecimal.valueOf(mi.price()));
                f.setCategory(Food.Category.valueOf(mi.category()));
                f.setImageUrl(foodImagePath(mi.name()));
                f.setPrepTimeMinutes(mi.prepMinutes());
                f.setAvailability(true);
                foodRepository.save(f);
                foodsAdded++;
            }
        }
        long totalShops = shopRepository.count();
        long totalFoods = foodRepository.count();
        System.out.println("SEEDER: shops ensured (" + shopsTouched + " definitions, "
                + totalShops + " total). Foods added this run: " + foodsAdded
                + " (" + totalFoods + " total).");
    }

    /**
     * Canonical local image path for a food item:
     *   /images/foods/&lt;kebab-case-name&gt;.png
     * PNG files are added manually to food-hub-frontend/public/images/foods/.
     * Until a file exists the UI shows a "no image" state (it does not break).
     */
    private static String foodImagePath(String name) {
        return "/images/foods/" + slug(name) + ".png";
    }

    // Give every food row a prep time + the canonical .png image path.
    private void repairFoodRows() {
        int repaired = 0;
        for (Food f : foodRepository.findAll()) {
            boolean dirty = false;
            if (f.getPrepTimeMinutes() == null) {
                f.setPrepTimeMinutes(15);
                dirty = true;
            }
            String img = f.getImageUrl();
            boolean needsCanonical = img == null || img.isBlank()
                    || img.startsWith("http")
                    || img.endsWith(".svg")            // migrate away from the removed SVGs
                    || !img.startsWith("/images/foods/");
            if (needsCanonical) {
                f.setImageUrl(foodImagePath(f.getName()));
                dirty = true;
            }
            if (dirty) {
                foodRepository.save(f);
                repaired++;
            }
        }
        if (repaired > 0) {
            System.out.println("SEEDER: repaired " + repaired + " food row(s) (image path/prep time).");
        }
    }

    // Backfill tracking fields on orders created before that feature existed.
    private void backfillOrderTracking() {
        int fixed = 0;
        for (Order o : orderRepository.findAll()) {
            boolean dirty = false;
            if (o.getPlacedAt() == null) {
                o.setPlacedAt(o.getCreatedAt());
                dirty = true;
            }
            if (o.getEstimatedPrepMinutes() == null) {
                int est = o.getItems().stream()
                        .map(i -> i.getFood() != null && i.getFood().getPrepTimeMinutes() != null
                                ? i.getFood().getPrepTimeMinutes() : 15)
                        .max(Integer::compareTo).orElse(15);
                o.setEstimatedPrepMinutes(est);
                dirty = true;
            }
            if (o.getFulfillmentStatus() == null) {
                o.setFulfillmentStatus(o.getOrderStatus() == Order.OrderStatus.COMPLETED
                        ? Order.FulfillmentStatus.COMPLETED
                        : Order.FulfillmentStatus.ORDER_PLACED);
                dirty = true;
            }
            if (dirty) {
                orderRepository.save(o);
                fixed++;
            }
        }
        if (fixed > 0) {
            System.out.println("SEEDER: backfilled tracking fields on " + fixed + " order(s).");
        }
    }

    private static String slug(String name) {
        return name.toLowerCase()
                .replaceAll("[^a-z0-9]+", "-")
                .replaceAll("(^-|-$)", "");
    }
}
