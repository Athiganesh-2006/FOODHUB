import axios from 'axios';

// Where the Spring Boot backend lives, set in exactly one place.
//
// Empty (the dev default) means same-origin: the Vite dev server proxies /api
// to http://localhost:8081, so no CORS preflight is involved and the app works
// on whichever port Vite ends up using. Set VITE_API_URL to an absolute URL for
// a deployed build — that origin must be in the backend's CORS allowlist.
export const API_BASE = import.meta.env.VITE_API_URL || '';

// localStorage keys. AuthContext owns writes; the interceptors below read them.
export const TOKEN_STORAGE_KEY = 'foodhub_token';
export const AUTH_STORAGE_KEY = 'foodhub_user';

export class ApiError extends Error {
  constructor(message, status, body) {
    super(message);
    this.name = 'ApiError';
    this.status = status;
    this.body = body;
  }
}

export function getToken() {
  try {
    return localStorage.getItem(TOKEN_STORAGE_KEY) || null;
  } catch {
    return null;
  }
}

function clearAuthStorage() {
  try {
    localStorage.removeItem(TOKEN_STORAGE_KEY);
    localStorage.removeItem(AUTH_STORAGE_KEY);
  } catch {
    // ignore
  }
}

const api = axios.create({ baseURL: API_BASE });

// Attach the JWT to every request: Authorization: Bearer <token>.
// The backend derives the user id from this token itself — the frontend never
// sends X-User-Id.
api.interceptors.request.use((config) => {
  const token = getToken();
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Responses are ApiResponse<T> = { success, message, data }. Unwrap to `data`.
// On 401 (missing / invalid / expired token) clear auth state and let the app
// redirect to /login — without crashing.
api.interceptors.response.use(
  (res) => {
    const body = res.data;
    if (body && typeof body === 'object' && 'success' in body) {
      if (!body.success) {
        throw new ApiError(body.message || 'Request failed', res.status, body);
      }
      res.data = body.data;
    }
    return res;
  },
  (error) => {
    if (error instanceof ApiError) return Promise.reject(error);

    const status = error.response && error.response.status;
    if (status === 401) {
      clearAuthStorage();
      // AuthContext listens for this and clears React state -> ProtectedRoute
      // navigates to /login. Guarded so it is a no-op outside the browser.
      if (typeof window !== 'undefined') {
        window.dispatchEvent(new CustomEvent('auth:unauthorized'));
      }
    }

    const body = error.response ? error.response.data : undefined;
    const message =
      (body && typeof body === 'object' && body.message) ||
      error.message ||
      `Network error — is the backend running on ${API_BASE || 'http://localhost:8081'}?`;
    return Promise.reject(new ApiError(message, status, body));
  },
);

export default api;
