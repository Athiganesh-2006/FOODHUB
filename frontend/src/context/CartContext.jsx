import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
} from "react";
import api from "../api/client";
import { useAuth } from "./AuthContext";
import { ROLES } from "../lib/roles";

const CartContext = createContext(null);

const EMPTY_CART = { cartId: null, customerId: null, items: [], totalAmount: 0 };

/**
 * The cart lives in the backend (GET/POST/PUT/DELETE /api/customer/cart).
 * Nothing here is kept only in React state — every mutation round-trips and the
 * server's CartDTO becomes the new state.
 */
export const CartProvider = ({ children }) => {
  const { user, token } = useAuth();
  const isCustomer = user?.role === ROLES.CUSTOMER && !!token;

  const [cart, setCart] = useState(EMPTY_CART);
  const [loading, setLoading] = useState(false);

  const refresh = useCallback(async () => {
    if (!isCustomer) {
      setCart(EMPTY_CART);
      return;
    }
    setLoading(true);
    try {
      const res = await api.get("/api/customer/cart");
      setCart(res.data || EMPTY_CART);
    } catch {
      setCart(EMPTY_CART);
    } finally {
      setLoading(false);
    }
  }, [isCustomer]);

  useEffect(() => {
    refresh();
  }, [refresh]);

  // The CartDTO a mutation returns is built inside the same transaction and
  // lags one change behind, so we always re-read the cart afterwards and use
  // that as the state. GET /api/customer/cart is authoritative.
  const reread = useCallback(async () => {
    const res = await api.get("/api/customer/cart");
    const fresh = res.data || EMPTY_CART;
    setCart(fresh);
    return fresh;
  }, []);

  // AddToCartRequest = { foodId, quantity }
  const addItem = useCallback(
    async (foodId, quantity = 1) => {
      await api.post("/api/customer/cart", { foodId, quantity });
      return reread();
    },
    [reread],
  );

  const updateItem = useCallback(
    async (cartItemId, quantity) => {
      await api.put(`/api/customer/cart/items/${cartItemId}`, null, {
        params: { quantity },
      });
      return reread();
    },
    [reread],
  );

  const removeItem = useCallback(
    async (cartItemId) => {
      await api.delete(`/api/customer/cart/items/${cartItemId}`);
      return reread();
    },
    [reread],
  );

  const clear = useCallback(async () => {
    await api.delete("/api/customer/cart/clear");
    setCart(EMPTY_CART);
  }, []);

  const value = useMemo(() => {
    const items = cart.items || [];
    return {
      cart,
      items,
      loading,
      refresh,
      addItem,
      updateItem,
      removeItem,
      clear,
      itemCount: items.reduce((n, i) => n + (i.quantity || 0), 0),
      total: Number(cart.totalAmount || 0),
    };
  }, [cart, loading, refresh, addItem, updateItem, removeItem, clear]);

  return (
    <CartContext.Provider value={value}>{children}</CartContext.Provider>
  );
};

export const useCart = () => {
  const ctx = useContext(CartContext);
  if (!ctx) throw new Error("useCart must be used within <CartProvider>");
  return ctx;
};
