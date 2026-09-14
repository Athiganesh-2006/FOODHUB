import { useState } from "react";

import api from "../../api/client";
import { useApi } from "../../lib/useApi";
import {
  dateTime,
  inr,
  minutesLabel,
  prettyStatus,
  timeOnly,
} from "../../lib/format";

// The next fulfillment step the owner can move an order to.
const NEXT_ACTION = {
  ORDER_PLACED: { status: "PREPARING", label: "Start Preparing" },
  PREPARING: { status: "READY_FOR_PICKUP", label: "Ready for Pickup" },
  READY_FOR_PICKUP: { status: "COMPLETED", label: "Complete Order" },
};

const Orders = () => {
  // GET /api/shop-owner/orders — the backend scopes this to the owner's own
  // shop using the JWT; the frontend cannot ask for another shop's orders.
  // New orders arrive while this screen is open, so poll in the background.
  const { data, loading, error, reload } = useApi("/api/shop-owner/orders", {
    pollMs: 5000,
  });
  const orders = data || [];

  const [busyId, setBusyId] = useState(null);
  const [actionError, setActionError] = useState("");

  // PATCH /api/shop-owner/orders/{orderId}/fulfillment?status=...
  const advance = async (orderId, status) => {
    setBusyId(orderId);
    setActionError("");
    try {
      await api.patch(
        `/api/shop-owner/orders/${orderId}/fulfillment`,
        null,
        { params: { status } },
      );
      await reload();
    } catch (e) {
      setActionError(e.message || "Could not update the order status.");
    } finally {
      setBusyId(null);
    }
  };

  return (
    <div className="orders-page">

      <div className="page-title orders-page-header">

        <div>
          <h1>Orders</h1>

          <p>Move each order through to pickup.</p>
        </div>

        <button
          className="secondary-button"
          onClick={reload}
        >
          Refresh
        </button>

      </div>

      {(error || actionError) && (
        <p className="error-message">{actionError || error}</p>
      )}

      {loading && orders.length === 0 ? (

        <p className="empty-message">Loading orders...</p>

      ) : orders.length === 0 ? (

        <div className="empty-cart">

          <h2>No orders yet</h2>

          <p>
            Customer orders for your shop will appear here.
          </p>

        </div>

      ) : (

        <div className="customer-orders-list">

          {orders.map((order) => {
            const current = order.fulfillmentStatus || "ORDER_PLACED";
            const next = NEXT_ACTION[current];

            return (
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
                      {order.customerName} · {dateTime(order.createdAt)}
                    </p>
                  </div>

                  <div className="order-header-status">

                    <span
                      className={
                        current === "COMPLETED"
                          ? "status-active"
                          : "status-pending"
                      }
                    >
                      {prettyStatus(current)}
                    </span>

                    <strong>{inr(order.totalAmount)}</strong>

                  </div>

                </div>


                <div className="customer-order-items">

                  {(order.items || []).map((item) => (

                    <div
                      className="customer-order-item"
                      key={item.id}
                    >
                      <span>
                        {item.foodName} × {item.quantity}
                      </span>

                      <strong>
                        {inr(Number(item.price) * item.quantity)}
                      </strong>
                    </div>

                  ))}

                </div>


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


                <div className="customer-order-footer">

                  <span>
                    Placed {timeOnly(order.placedAt) || "—"}
                    {order.preparingAt &&
                      ` · Preparing ${timeOnly(order.preparingAt)}`}
                    {order.readyAt && ` · Ready ${timeOnly(order.readyAt)}`}
                    {order.completedAt &&
                      ` · Completed ${timeOnly(order.completedAt)}`}
                  </span>

                  {next ? (
                    <button
                      className="primary-button"
                      disabled={busyId === order.id}
                      onClick={() => advance(order.id, next.status)}
                    >
                      {busyId === order.id ? "Updating..." : next.label}
                    </button>
                  ) : (
                    <span className="status-active">Completed</span>
                  )}

                </div>

              </div>
            );
          })}

        </div>

      )}

    </div>
  );
};

export default Orders;
