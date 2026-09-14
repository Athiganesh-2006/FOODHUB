import { useState } from "react";
import { useNavigate, useParams } from "react-router-dom";

import { useApi } from "../../lib/useApi";
import { useCart } from "../../context/CartContext";
import FoodImage from "../../components/FoodImage";
import { inr, minutesLabel, prettyCategory } from "../../lib/format";

const ShopFood = () => {
  const { shopId } = useParams();
  const navigate = useNavigate();
  const { addItem } = useCart();

  const [busyId, setBusyId] = useState(null);
  const [addedId, setAddedId] = useState(null);

  // GET /api/customer/shops/{id} and /api/customer/shops/{id}/foods.
  // The shop-to-food relationship is the backend's — only this shop's items
  // are ever requested or shown.
  const {
    data: shop,
    loading: shopLoading,
    error: shopError,
  } = useApi(`/api/customer/shops/${shopId}`, { pollMs: 10000 });

  const {
    data: foods,
    loading: foodsLoading,
    error: foodsError,
  } = useApi(`/api/customer/shops/${shopId}/foods`, { pollMs: 10000 });

  const handleAddToCart = async (food) => {
    // Stays on this page instead of jumping to the cart, so adding several
    // items (from this shop, or others — the cart now allows more than one)
    // does not get interrupted after every tap. The button flashes "Added" and
    // the nav cart badge updates as confirmation.
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

  if (shopLoading) {
    return (
      <div className="shop-food-page">
        <p className="empty-message">Loading shop...</p>
      </div>
    );
  }

  /* SHOP NOT FOUND */

  if (shopError || !shop) {
    return (
      <div className="shop-food-page">

        <div className="empty-message">

          <h2>Shop not found</h2>

          <p>
            {shopError || "The shop you are looking for does not exist."}
          </p>

          <button
            className="primary-button"
            onClick={() => navigate("/customer/shops")}
          >
            Back to Shops
          </button>

        </div>

      </div>
    );
  }

  /* SHOP CLOSED */

  if (shop.availability !== "OPEN") {
    return (
      <div className="shop-food-page">

        <div className="empty-message">

          <h2>{shop.name} is currently closed</h2>

          <p>
            Please check again later.
          </p>

          <button
            className="primary-button"
            onClick={() => navigate("/customer/shops")}
          >
            Back to Shops
          </button>

        </div>

      </div>
    );
  }

  const availableFood = foods || [];

  return (
    <div className="shop-food-page">

      {/* SHOP HEADER */}

      <div className="page-title">

        <button
          className="secondary-button"
          onClick={() => navigate("/customer/shops")}
        >
          Back to Shops
        </button>


        <h1>
          {shop.name}
        </h1>


        <p>
          {shop.address}
        </p>


        <p>
          {shop.description}
        </p>

      </div>

      {foodsError && <p className="error-message">{foodsError}</p>}


      {/* FOOD ITEMS */}

      {foodsLoading ? (

        <p className="empty-message">Loading food items...</p>

      ) : availableFood.length === 0 ? (

        <div className="empty-message">

          <h2>
            No food items available
          </h2>

          <p>
            This shop currently has no available food.
          </p>

        </div>

      ) : (

        <div className="food-grid">

          {availableFood.map((food) => (

            <div
              className="customer-food-card"
              key={food.id}
            >

              <FoodImage src={food.imageUrl} alt={food.name} />


              <div className="food-card-content">

                <div className="food-card-top">

                  <h3>
                    {food.name}
                  </h3>

                  <span className="status-active">
                    Available
                  </span>

                </div>


                <p className="food-category">
                  {prettyCategory(food.category)}
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
                    disabled={busyId === food.id}
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

          ))}

        </div>

      )}

    </div>
  );
};

export default ShopFood;
