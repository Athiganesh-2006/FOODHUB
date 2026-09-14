// Prices from the backend are BigDecimal serialized as numbers/strings.
export function inr(value) {
  const n = Number(value == null ? 0 : value);
  return '₹' + (Number.isFinite(n) ? n : 0).toFixed(2);
}

export function dateTime(value) {
  if (!value) return '—';
  const d = new Date(value);
  return Number.isNaN(d.getTime()) ? String(value) : d.toLocaleString();
}

// e.g. "11:42 AM"
export function timeOnly(value) {
  if (!value) return null;
  const d = new Date(value);
  if (Number.isNaN(d.getTime())) return null;
  return d.toLocaleTimeString([], { hour: 'numeric', minute: '2-digit' });
}

// ORDER_PLACED -> "Order Placed", READY_FOR_PICKUP -> "Ready for Pickup"
const STATUS_WORDS = {
  ORDER_PLACED: 'Order Placed',
  PREPARING: 'Preparing',
  READY_FOR_PICKUP: 'Ready for Pickup',
  COMPLETED: 'Completed',
};
export function prettyStatus(s) {
  if (!s) return '';
  return STATUS_WORDS[s] || String(s).replace(/_/g, ' ');
}

export function minutesLabel(m) {
  return m == null ? '—' : `~${m} min`;
}

// The fulfillment lifecycle, in order (backend Order.FulfillmentStatus).
export const FULFILLMENT_STEPS = [
  'ORDER_PLACED',
  'PREPARING',
  'READY_FOR_PICKUP',
  'COMPLETED',
];

// Food.Category enum on the backend.
export const FOOD_CATEGORIES = [
  'BREAKFAST',
  'LUNCH',
  'DINNER',
  'SNACKS',
  'BEVERAGES',
  'FAST_FOOD',
  'DESSERTS',
];

export function prettyCategory(c) {
  return c ? String(c).replace(/_/g, ' ') : '';
}
