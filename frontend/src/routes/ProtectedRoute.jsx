import { Navigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { roleHome } from "../lib/roles";

/**
 * Route guard. The real authorization lives in the backend (Spring Security +
 * the JWT); this only keeps the UI from showing a screen the API would reject.
 */
const ProtectedRoute = ({ children, allowedRole }) => {
  const { user, isAuthenticated } = useAuth();

  if (!isAuthenticated) {
    return <Navigate to="/login" replace />;
  }

  if (allowedRole && user.role !== allowedRole) {
    return <Navigate to={roleHome(user.role)} replace />;
  }

  return children;
};

export default ProtectedRoute;
