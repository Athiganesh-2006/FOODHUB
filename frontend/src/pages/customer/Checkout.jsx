import { useState } from "react";
import { useNavigate } from "react-router-dom";

import { useCart } from "../../context/CartContext";
import { inr } from "../../lib/format";

// Payment methods the backend CheckoutRequest understands.
export const PAYMENT_METHODS = [
  { id: "DUMMY_CARD", label: "Card (dummy)" },
  { id: "CASH_ON_DELIVERY", label: "Cash on pickup" },
];

const Checkout = () => {
  const { items, total, itemCount } = useCart();
  const navigate = useNavigate();

  const [paymentMethod, setPaymentMethod] = useState("DUMMY_CARD");

  const handleSubmit = (e) => {
    e.preventDefault();

    if (items.length === 0) {
      navigate("/customer/cart");
      return;
    }

    // The order itself is placed on the Payment screen, against the cart the
    // backend already holds — only the chosen method travels with the route.
    navigate("/customer/payment", {
      state: { paymentMethod },
    });
  };

  /* EMPTY CART */

  if (items.length === 0) {
    return (
      <div className="checkout-page">

        <div className="empty-cart">

          <h2>Your cart is empty</h2>

          <p>
            Add some food items before checking out.
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
    <div className="checkout-page">

      {/* PAGE HEADER */}

      <div className="page-title">

        <h1>Checkout</h1>

        <p>
          Review your order and choose a payment method.
        </p>

      </div>


      <div className="checkout-container">

        {/* PAYMENT METHOD */}

        <div className="checkout-card">

          <h2>
            Payment Method
          </h2>

          <form onSubmit={handleSubmit}>

            <div className="payment-options">

              {PAYMENT_METHODS.map((method) => (

                <label className="payment-option" key={method.id}>

                  <input
                    type="radio"
                    name="paymentMethod"
                    value={method.id}
                    checked={paymentMethod === method.id}
                    onChange={(e) => setPaymentMethod(e.target.value)}
                  />

                  <span>
                    {method.label}
                  </span>

                </label>

              ))}

            </div>


            <button
              type="submit"
              className="checkout-button"
            >
              Continue to Payment
            </button>

          </form>

        </div>


        {/* ORDER SUMMARY */}

        <div className="checkout-summary">

          <h2>
            Order Summary
          </h2>


          {items.map((item) => (

            <div
              className="checkout-item"
              key={item.cartItemId}
            >

              <div>

                <strong>
                  {item.foodName}
                </strong>

                <p className="cart-shop-name">
                  {item.shopName}
                </p>

                <p>
                  {inr(item.price)} × {item.quantity}
                </p>

              </div>


              <strong>
                {inr(item.subtotal)}
              </strong>

            </div>

          ))}


          <hr />


          <div className="summary-row">

            <span>
              Items
            </span>

            <span>
              {itemCount}
            </span>

          </div>


          <div className="summary-total">

            <span>
              Total
            </span>

            <strong>
              {inr(total)}
            </strong>

          </div>

        </div>

      </div>

    </div>
  );
};

export default Checkout;
