import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
} from "react";
import api, { AUTH_STORAGE_KEY, TOKEN_STORAGE_KEY } from "../api/client";

const AuthContext = createContext(null);

function readStored(key) {
  try {
    return localStorage.getItem(key);
  } catch {
    return null;
  }
}

function readStoredUser() {
  const raw = readStored(AUTH_STORAGE_KEY);
  try {
    return raw ? JSON.parse(raw) : null;
  } catch {
    return null;
  }
}

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(readStoredUser);
  const [token, setToken] = useState(() => readStored(TOKEN_STORAGE_KEY));

  const logout = useCallback(() => {
    try {
      localStorage.removeItem(TOKEN_STORAGE_KEY);
      localStorage.removeItem(AUTH_STORAGE_KEY);
    } catch {
      // ignore
    }
    setUser(null);
    setToken(null);
  }, []);

  // POST /api/auth/login -> { token, user:{ id, name, email, phone, address, role } }
  // Store both; the axios interceptor sends `Authorization: Bearer <token>`.
  const login = useCallback(async (email, password) => {
    const res = await api.post("/api/auth/login", { email, password });
    const { token: jwt, user: authUser } = res.data || {};
    if (!jwt || !authUser || authUser.id == null) {
      throw new Error("Unexpected login response from server");
    }
    try {
      localStorage.setItem(TOKEN_STORAGE_KEY, jwt);
      localStorage.setItem(AUTH_STORAGE_KEY, JSON.stringify(authUser));
    } catch {
      // storage may be unavailable; state below still works for this session
    }
    setToken(jwt);
    setUser(authUser);
    return authUser;
  }, []);

  // The API client dispatches this on any 401 (expired / invalid / missing JWT).
  useEffect(() => {
    const onUnauthorized = () => logout();
    window.addEventListener("auth:unauthorized", onUnauthorized);
    return () => window.removeEventListener("auth:unauthorized", onUnauthorized);
  }, [logout]);

  const value = useMemo(
    () => ({
      user,
      token,
      isAuthenticated: !!user && !!token,
      login,
      logout,
    }),
    [user, token, login, logout],
  );

  return (
    <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
  );
};

export const useAuth = () => {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be used within <AuthProvider>");
  return ctx;
};
