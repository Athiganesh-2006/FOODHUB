import { FULFILLMENT_STEPS, prettyStatus, timeOnly } from "../lib/format";

const TS_FIELD = {
  ORDER_PLACED: "placedAt",
  PREPARING: "preparingAt",
  READY_FOR_PICKUP: "readyAt",
  COMPLETED: "completedAt",
};

/**
 * Progress tracker for an order's pickup lifecycle. Every timestamp and the
 * estimated ready time come straight off the backend OrderDTO — nothing is
 * recomputed or faked here.
 */
const OrderTracker = ({ order }) => {
  const current = order.fulfillmentStatus || "ORDER_PLACED";
  const currentIdx = Math.max(0, FULFILLMENT_STEPS.indexOf(current));

  return (
    <div className="tracker">
      {FULFILLMENT_STEPS.map((step, i) => {
        const state =
          i < currentIdx ? "done" : i === currentIdx ? "current" : "pending";
        const actual = timeOnly(order[TS_FIELD[step]]);

        let timeEl;
        if (actual) {
          timeEl = <div className="tracker-time">{actual}</div>;
        } else if (step === "READY_FOR_PICKUP" && order.estimatedReadyAt) {
          timeEl = (
            <div className="tracker-time est">
              Estimated {timeOnly(order.estimatedReadyAt)}
            </div>
          );
        } else {
          timeEl = <div className="tracker-time">—</div>;
        }

        return (
          <div className={`tracker-step ${state}`} key={step}>
            <div className="tracker-dot" />
            <div className="tracker-body">
              <div className="tracker-label">{prettyStatus(step)}</div>
              {timeEl}
            </div>
          </div>
        );
      })}
    </div>
  );
};

export default OrderTracker;
