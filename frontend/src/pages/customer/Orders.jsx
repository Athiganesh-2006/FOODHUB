import { useNavigate } from "react-router-dom";

import { useApi } from "../../lib/useApi";
import OrderTracker from "../../components/OrderTracker";
import {
  dateTime,
  inr,
  minutesLabel,
  prettyStatus,
  timeOnly,
} from "../../lib/format";

const CustomerOrders = () => {
  const navigate = useNavigate();

  // GET /api/customer/orders -> OrderDTO[] for the authenticated customer.
  // Polled in the background so a shop owner moving the order to Preparing /
  // Ready shows up here on its own, with no spinner flash over the tracker.
  const { data, loading, error, reload } = useApi("/api/customer/orders", {
    pollMs: 5000,
  });
  const orders = data || [];

  return (
    <div className="orders-page">

      <div className="page-title orders-page-header">

        <div>
          <h1>My Orders</h1>

          <p>Track your Q-Free orders through to pickup.</p>
        </div>

        <button
          className="secondary-button"
          onClick={reload}
        >
          Refresh
        </button>

      </div>

      {error && <p className="error-message">{error}</p>}

      {loading && orders.length === 0 ? (

        <p className="empty-message">Loading your orders...</p>

      ) : orders.length === 0 ? (

        <div className="empty-cart">

          <h2>No orders yet</h2>

          <p>
            Your orders will appear here once you place one.
          </p>

          <button
            className="primary-button"
            onClick={() => navigate("/customer/home")}
          >
            Browse Food
          </button>

        </div>

      ) : (

        <div className="customer-orders-list">

          {orders.map((order) => (

            <div
              className="customer-order-card"
              key={order.id}
            >

              <div className="customer-order-header">

                <div>
                  <h3>
                    Order #{order.id}
                  </h3>

                  <p>
                    {dateTime(order.createdAt)}
                  </p>
                </div>

                <div className="order-header-status">

                  <span
                    className={
                      order.fulfillmentStatus === "COMPLETED"
                        ? "status-active"
                        : "status-pending"
                    }
                  >
                    {prettyStatus(order.fulfillmentStatus)}
                  </span>

                  <strong>{inr(order.totalAmount)}</strong>

                </div>

              </div>


              <div className="order-body">

                {/* ORDER TRACKING */}

                <div className="order-tracking">

                  <OrderTracker order={order} />

                  <p className="order-estimate">
                    Estimated preparation time{" "}
                    <strong>{minutesLabel(order.estimatedPrepMinutes)}</strong>
                    {order.estimatedReadyAt && (
                      <>
                        {" · ready around "}
                        <strong>{timeOnly(order.estimatedReadyAt)}</strong>
                      </>
                    )}
                  </p>

                </div>


                {/* ITEMS */}

                <div className="customer-order-items">

                  {(order.items || []).map((item) => (

                    <div
                      className="customer-order-item"
                      key={item.id}
                    >
                      <span>
                        {item.foodName} × {item.quantity}
                        <small className="cart-shop-name">
                          {item.shopName}
                        </small>
                      </span>

                      <strong>
                        {inr(Number(item.price) * item.quantity)}
                      </strong>
                    </div>

                  ))}

                </div>

              </div>


              <div className="customer-order-footer">

                <span>
                  Payment:{" "}
                  <strong>
                    {order.paymentStatus}
                  </strong>
                </span>

                <span>
                  Total:{" "}
                  <strong>
                    {inr(order.totalAmount)}
                  </strong>
                </span>

              </div>

            </div>

          ))}

        </div>

      )}

    </div>
  );
};

export default CustomerOrders;
