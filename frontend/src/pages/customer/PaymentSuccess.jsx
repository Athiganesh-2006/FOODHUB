import { useLocation, useNavigate } from "react-router-dom";
import { inr, minutesLabel } from "../../lib/format";

const PaymentSuccess = () => {
  const location = useLocation();
  const navigate = useNavigate();

  // Everything here comes from the OrderDTO the backend returned at checkout.
  const { orderId, total, paymentStatus, estimatedPrepMinutes } =
    location.state || {};

  return (
    <div className="payment-success-page">

      <div className="success-card">

        <div className="success-icon">
          ✓
        </div>

        <h1>Order Placed Successfully!</h1>

        <p>
          Your food order has been placed successfully.
        </p>

        {orderId && (
          <div className="order-success-details">

            <div>
              <p>Order ID</p>
              <strong>#{orderId}</strong>
            </div>

            <div>
              <p>Total Amount</p>
              <strong>{inr(total)}</strong>
            </div>

            <div>
              <p>Payment</p>
              <strong>{paymentStatus || "—"}</strong>
            </div>

            <div>
              <p>Estimated Prep Time</p>
              <strong>{minutesLabel(estimatedPrepMinutes)}</strong>
            </div>

          </div>
        )}

        <div className="success-message">
          <p>
            Your order is being prepared.
          </p>

          <p>
            Track it under My Orders and collect it from the
            shop when it is ready for pickup.
          </p>
        </div>

        <div className="success-actions">

          <button
            className="primary-button"
            onClick={() => navigate("/customer/orders")}
          >
            View My Orders
          </button>

          <button
            className="secondary-button"
            onClick={() => navigate("/customer/home")}
          >
            Continue Shopping
          </button>

        </div>

      </div>

    </div>
  );
};

export default PaymentSuccess;
