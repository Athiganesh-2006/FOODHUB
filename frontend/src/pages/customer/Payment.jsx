import { useState } from "react";
import { useLocation, useNavigate } from "react-router-dom";

import api from "../../api/client";
import { useCart } from "../../context/CartContext";
import { inr } from "../../lib/format";

const LABELS = {
  DUMMY_CARD: "Card (dummy)",
  CASH_ON_DELIVERY: "Cash on pickup",
};

const Payment = () => {
  const location = useLocation();
  const navigate = useNavigate();

  const { items, total, itemCount, refresh } = useCart();

  const paymentMethod = location.state?.paymentMethod || "DUMMY_CARD";

  const [isProcessing, setIsProcessing] = useState(false);
  const [error, setError] = useState("");

  const [cardDetails, setCardDetails] = useState({
    cardNumber: "",
    expiry: "",
    cvv: "",
  });

  /* NOTHING TO PAY FOR */

  if (items.length === 0) {
    return (
      <div className="payment-page">

        <div className="empty-cart">

          <h2>Your cart is empty</h2>

          <p>
            Please go through the checkout process first.
          </p>

          <button
            className="primary-button"
            onClick={() => navigate("/customer/cart")}
          >
            Back to Cart
          </button>

        </div>

      </div>
    );
  }

  const handleCardChange = (e) => {
    const { name, value } = e.target;

    setCardDetails((currentDetails) => ({
      ...currentDetails,
      [name]: value,
    }));
  };

  /* PLACE THE ORDER */

  const handlePayment = async () => {
    if (paymentMethod === "DUMMY_CARD") {
      if (
        !cardDetails.cardNumber.trim() ||
        !cardDetails.expiry.trim() ||
        !cardDetails.cvv.trim()
      ) {
        setError("Please enter all card details.");
        return;
      }
    }

    setIsProcessing(true);
    setError("");

    try {
      // POST /api/customer/checkout — CheckoutRequest is just { paymentMethod }.
      // The backend builds the order from the cart it holds and recomputes the
      // total from DB prices, so no items or amounts are sent from here.
      const res = await api.post("/api/customer/checkout", { paymentMethod });
      const order = res.data;

      await refresh();

      navigate("/customer/payment-success", {
        state: {
          orderId: order.id,
          total: order.totalAmount,
          paymentStatus: order.paymentStatus,
          estimatedPrepMinutes: order.estimatedPrepMinutes,
        },
        replace: true,
      });
    } catch (e) {
      setError(e.message || "Checkout failed. Please try again.");
    } finally {
      setIsProcessing(false);
    }
  };

  return (
    <div className="payment-page">

      {/* PAGE HEADER */}

      <div className="page-title">

        <h1>Payment</h1>

        <p>
          Complete your payment to place your order.
        </p>

      </div>


      <div className="payment-container">

        {/* PAYMENT CARD */}

        <div className="payment-card">

          <h2>
            {LABELS[paymentMethod] || paymentMethod}
          </h2>


          {/* CARD */}

          {paymentMethod === "DUMMY_CARD" && (

            <>

              <div className="payment-input">

                <label htmlFor="cardNumber">
                  Card Number
                </label>

                <input
                  id="cardNumber"
                  type="text"
                  name="cardNumber"
                  placeholder="1234 5678 9012 3456"
                  value={cardDetails.cardNumber}
                  onChange={handleCardChange}
                  autoComplete="off"
                />

              </div>


              <div className="card-row">

                <div className="payment-input">

                  <label htmlFor="expiry">
                    Expiry
                  </label>

                  <input
                    id="expiry"
                    type="text"
                    name="expiry"
                    placeholder="MM/YY"
                    maxLength="5"
                    value={cardDetails.expiry}
                    onChange={handleCardChange}
                    autoComplete="off"
                  />

                </div>


                <div className="payment-input">

                  <label htmlFor="cvv">
                    CVV
                  </label>

                  <input
                    id="cvv"
                    type="password"
                    name="cvv"
                    placeholder="123"
                    maxLength="3"
                    value={cardDetails.cvv}
                    onChange={handleCardChange}
                    autoComplete="off"
                  />

                </div>

              </div>


              <p className="payment-note">
                This is a dummy card screen — no card details leave this page.
              </p>

            </>

          )}


          {/* CASH */}

          {paymentMethod === "CASH_ON_DELIVERY" && (

            <div className="cod-message">

              <h3>Cash Payment</h3>

              <p>
                You can pay by cash when you collect
                your order from the shop.
              </p>

            </div>

          )}


          {error && (
            <p className="error-message">{error}</p>
          )}


          {/* PAYMENT BUTTON */}

          <button
            type="button"
            className="checkout-button"
            onClick={handlePayment}
            disabled={isProcessing}
          >

            {isProcessing
              ? "Placing order..."
              : paymentMethod === "CASH_ON_DELIVERY"
              ? "Place Order"
              : `Pay ${inr(total)}`}

          </button>

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

export default Payment;
