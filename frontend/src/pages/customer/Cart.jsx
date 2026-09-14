import { useState } from "react";
import { useNavigate } from "react-router-dom";

import { useCart } from "../../context/CartContext";
import FoodImage from "../../components/FoodImage";
import { inr } from "../../lib/format";

const Cart = () => {
  const {
    items,
    total,
    itemCount,
    loading,
    updateItem,
    removeItem,
    clear,
  } = useCart();

  const navigate = useNavigate();

  const [busyId, setBusyId] = useState(null);
  const [error, setError] = useState("");

  // Every quantity/remove action is a backend call; the CartDTO that comes
  // back replaces the local state, so the totals are always the server's.
  const run = async (id, fn) => {
    setBusyId(id);
    setError("");
    try {
      await fn();
    } catch (e) {
      setError(e.message || "Could not update your cart.");
    } finally {
      setBusyId(null);
    }
  };

  if (loading && items.length === 0) {
    return (
      <div className="cart-page">
        <div className="page-title">
          <h1>Your Cart</h1>
        </div>
        <p className="empty-message">Loading your cart...</p>
      </div>
    );
  }

  /* EMPTY CART */

  if (items.length === 0) {
    return (
      <div className="cart-page">

        <div className="page-title">
          <h1>Your Cart</h1>

          <p>
            Review the items you want to order.
          </p>
        </div>

        <div className="empty-cart">

          <h2>Your cart is empty</h2>

          <p>
            Add some food items to your cart to continue.
          </p>

          <button
            className="primary-button"
            onClick={() => navigate("/customer/home")}
          >
            Browse Food
          </button>

        </div>

      </div>
    );
  }

  return (
    <div className="cart-page">

      {/* PAGE HEADER */}

      <div className="page-title">

        <h1>Your Cart</h1>

        <p>
          Review your items before checkout.
        </p>

      </div>

      {error && <p className="error-message">{error}</p>}


      <div className="cart-container">

        {/* CART ITEMS */}

        <div className="cart-items">

          {items.map((item) => (

            <div
              className="cart-item"
              key={item.cartItemId}
            >

              <FoodImage
                src={item.imageUrl}
                alt={item.foodName}
                className="cart-item-image"
              />


              <div className="cart-item-details">

                <h3>
                  {item.foodName}
                </h3>

                <p className="cart-shop-name">
                  {item.shopName}
                </p>

                <strong>
                  {inr(item.price)}
                </strong>

              </div>


              {/* QUANTITY */}

              <div className="quantity-controls">

                <button
                  type="button"
                  disabled={busyId === item.cartItemId}
                  onClick={() =>
                    run(item.cartItemId, () =>
                      updateItem(item.cartItemId, item.quantity - 1),
                    )
                  }
                >
                  −
                </button>

                <span>
                  {item.quantity}
                </span>

                <button
                  type="button"
                  disabled={busyId === item.cartItemId}
                  onClick={() =>
                    run(item.cartItemId, () =>
                      updateItem(item.cartItemId, item.quantity + 1),
                    )
                  }
                >
                  +
                </button>

              </div>


              {/* ITEM TOTAL */}

              <div className="cart-item-total">

                {inr(item.subtotal)}

              </div>


              {/* REMOVE */}

              <button
                type="button"
                className="delete-button"
                disabled={busyId === item.cartItemId}
                onClick={() =>
                  run(item.cartItemId, () => removeItem(item.cartItemId))
                }
              >
                Remove
              </button>

            </div>

          ))}

        </div>


        {/* ORDER SUMMARY */}

        <div className="cart-summary">

          <h2>
            Order Summary
          </h2>


          <div className="summary-row">

            <span>
              Items
            </span>

            <span>
              {itemCount}
            </span>

          </div>


          <div className="summary-row">

            <span>
              Subtotal
            </span>

            <strong>
              {inr(total)}
            </strong>

          </div>


          <hr />


          <div className="summary-total">

            <span>
              Total
            </span>

            <strong>
              {inr(total)}
            </strong>

          </div>


          <button
            className="checkout-button"
            onClick={() => navigate("/customer/checkout")}
          >
            Proceed to Checkout
          </button>


          <button
            type="button"
            className="secondary-button cart-clear-button"
            onClick={() => run("clear", clear)}
          >
            Clear Cart
          </button>

        </div>

      </div>

    </div>
  );
};

export default Cart;
