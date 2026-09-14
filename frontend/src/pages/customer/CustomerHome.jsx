import { useCallback, useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";

import api from "../../api/client";
import { useApi } from "../../lib/useApi";
import { useCart } from "../../context/CartContext";
import FoodImage from "../../components/FoodImage";
import {
  FOOD_CATEGORIES,
  inr,
  minutesLabel,
  prettyCategory,
} from "../../lib/format";

const CustomerHome = () => {
  const { addItem } = useCart();
  const navigate = useNavigate();

  const [search, setSearch] = useState("");
  const [selectedCategory, setSelectedCategory] = useState("All");
  const [busyId, setBusyId] = useState(null);
  const [addedId, setAddedId] = useState(null);

  // GET /api/customer/shops
  const {
    data: shops,
    loading: shopsLoading,
    error: shopsError,
  } = useApi("/api/customer/shops", { pollMs: 10000 });

  const [foods, setFoods] = useState([]);
  const [foodsLoading, setFoodsLoading] = useState(true);
  const [foodsError, setFoodsError] = useState(null);

  // Foods come from the backend only:
  //   a category is picked -> GET /api/customer/foods/category?category=...
  //   "All"                -> GET /api/customer/shops/{id}/foods for each shop
  const loadFoods = useCallback(async () => {
    setFoodsLoading(true);
    setFoodsError(null);
    try {
      if (selectedCategory !== "All") {
        const res = await api.get("/api/customer/foods/category", {
          params: { category: selectedCategory },
        });
        setFoods(res.data || []);
      } else {
        const shopList = shops || [];
        const results = await Promise.all(
          shopList.map((shop) =>
            api
              .get(`/api/customer/shops/${shop.id}/foods`)
              .then((res) => res.data || [])
              .catch(() => []),
          ),
        );
        setFoods(results.flat());
      }
    } catch (e) {
      setFoodsError(e.message || "Failed to load food items");
      setFoods([]);
    } finally {
      setFoodsLoading(false);
    }
  }, [selectedCategory, shops]);

  useEffect(() => {
    if (selectedCategory === "All" && !shops) return;
    loadFoods();
  }, [loadFoods, selectedCategory, shops]);

  const searchText = search.trim().toLowerCase();

  const filteredFoodItems = foods.filter((food) => {
    if (!searchText) return true;
    return (
      (food.name || "").toLowerCase().includes(searchText) ||
      (food.category || "").toLowerCase().includes(searchText) ||
      (food.shopName || "").toLowerCase().includes(searchText)
    );
  });

  const filteredShops = (shops || []).filter((shop) => {
    if (!searchText) return true;
    return (
      (shop.name || "").toLowerCase().includes(searchText) ||
      (shop.address || "").toLowerCase().includes(searchText)
    );
  });

  // POST /api/customer/cart { foodId, quantity }. Stays on this page instead
  // of jumping to the cart, so browsing and adding items from several shops
  // (the cart now allows that) does not get interrupted after every tap. The
  // button flashes "Added" and the nav cart badge updates as confirmation.
  const handleAddToCart = async (food) => {
    setBusyId(food.id);
    try {
      await addItem(food.id, 1);
      setAddedId(food.id);
      setTimeout(() => setAddedId((id) => (id === food.id ? null : id)), 1500);
    } catch (e) {
      window.alert(e.message || "Could not add this item to your cart.");
    } finally {
      setBusyId(null);
    }
  };

  return (
    <div className="customer-home">

      {/* HERO */}

      <div className="customer-hero">

        <div className="customer-hero-content">
          <h1>What are you craving today?</h1>

          <p>
            Find your favourite food from Q-Free shops.
          </p>
        </div>

        <div className="customer-search">

          <input
            type="text"
            placeholder="Search shops, food or categories..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />

          <span>Search</span>

        </div>

      </div>


      {/* CATEGORIES */}

      <section className="customer-section">

        <div className="section-heading">

          <div>
            <h2>Categories</h2>

            <p>
              Choose what you feel like eating.
            </p>
          </div>

        </div>


        <div className="category-grid">

          <button
            className={
              selectedCategory === "All"
                ? "category-card selected"
                : "category-card"
            }
            onClick={() => setSelectedCategory("All")}
          >
            <strong>All</strong>
          </button>


          {FOOD_CATEGORIES.map((category) => (

            <button
              key={category}
              className={
                selectedCategory === category
                  ? "category-card selected"
                  : "category-card"
              }
              onClick={() => setSelectedCategory(category)}
            >
              <strong>{prettyCategory(category)}</strong>
            </button>

          ))}

        </div>

      </section>


      {/* SHOPS */}

      <section className="customer-section">

        <div className="section-heading">

          <div>
            <h2>Shops</h2>

            <p>
              Explore food from the Q-Free cafeteria shops.
            </p>
          </div>

        </div>

        {shopsError && (
          <p className="error-message">{shopsError}</p>
        )}

        {shopsLoading ? (

          <p className="empty-message">Loading shops...</p>

        ) : (

          <div className="shop-grid">

            {filteredShops.length > 0 ? (

              filteredShops.map((shop) => (

                <div
                  className="customer-shop-card"
                  key={shop.id}
                >

                  <div className="shop-card-content">

                    <h3>{shop.name}</h3>

                    <p>
                      {shop.address}
                    </p>


                    <div className="shop-card-footer">

                      <span>
                        {shop.foodItemCount ?? 0} items
                      </span>

                      <span
                        className={
                          shop.availability === "OPEN"
                            ? "shop-open"
                            : "shop-closed"
                        }
                      >
                        {shop.availability === "OPEN" ? "Open" : "Closed"}
                      </span>

                    </div>


                    <button
                      className="secondary-button shop-view-button"
                      disabled={shop.availability !== "OPEN"}
                      onClick={() =>
                        navigate(`/customer/shops/${shop.id}`)
                      }
                    >
                      View Food
                    </button>

                  </div>

                </div>

              ))

            ) : (

              <p className="empty-message">
                No shops found.
              </p>

            )}

          </div>

        )}

      </section>


      {/* FOOD ITEMS */}

      <section className="customer-section">

        <div className="section-heading">

          <div>

            <h2>Food Items</h2>

            <p>
              {selectedCategory === "All"
                ? "Everything available across the shops right now."
                : `Showing ${prettyCategory(selectedCategory)} items.`}
            </p>

          </div>

        </div>

        {foodsError && (
          <p className="error-message">{foodsError}</p>
        )}

        {foodsLoading ? (

          <p className="empty-message">Loading food items...</p>

        ) : (

          <div className="food-grid">

            {filteredFoodItems.length > 0 ? (

              filteredFoodItems.map((food) => (

                <div
                  className="customer-food-card"
                  key={food.id}
                >

                  <FoodImage src={food.imageUrl} alt={food.name} />


                  <div className="food-card-content">

                    <div className="food-card-top">

                      <h3>{food.name}</h3>

                      <span
                        className={
                          food.availability
                            ? "status-active"
                            : "status-inactive"
                        }
                      >
                        {food.availability ? "Available" : "Unavailable"}
                      </span>

                    </div>


                    <p className="food-category">
                      {prettyCategory(food.category)} · {food.shopName}
                    </p>


                    <p className="food-description">
                      {food.description}
                    </p>


                    <p className="food-prep">
                      Prep time {minutesLabel(food.prepTimeMinutes)}
                    </p>


                    <div className="food-card-bottom">

                      <strong>
                        {inr(food.price)}
                      </strong>

                      <button
                        className="primary-button"
                        disabled={!food.availability || busyId === food.id}
                        onClick={() => handleAddToCart(food)}
                      >
                        {busyId === food.id
                          ? "Adding..."
                          : addedId === food.id
                          ? "Added ✓"
                          : "Add to Cart"}
                      </button>

                    </div>

                  </div>

                </div>

              ))

            ) : (

              <p className="empty-message">
                No food items found.
              </p>

            )}

          </div>

        )}

      </section>

    </div>
  );
};

export default CustomerHome;
