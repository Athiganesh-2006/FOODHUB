import { NavLink, Outlet, useNavigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import logo from "../assets/q-free-logo.png";
const ShopOwnerLayout = () => {
  const { user, logout } = useAuth();
  const navigate = useNavigate();

  const handleLogout = () => {
    logout();
    navigate("/login");
  };

  return (
    <div className="admin-layout">

      <aside className="admin-sidebar">

        <div className="sidebar-logo">
  <img
    src={logo}
    alt="Q-Free"
    className="sidebar-logo-image"
  />
</div>

        <nav className="sidebar-menu">

          <NavLink to="/shop-owner/dashboard">
            Dashboard
          </NavLink>

          <NavLink to="/shop-owner/shop">
            My Shop
          </NavLink>

          <NavLink to="/shop-owner/food-items">
            Food Items
          </NavLink>

          <NavLink to="/shop-owner/orders">
            Orders
          </NavLink>

          <NavLink to="/shop-owner/profile">
            Profile
          </NavLink>

        </nav>

        <button
          className="logout-button"
          onClick={handleLogout}
        >
          Logout
        </button>

      </aside>

      <main className="admin-main">

        <header className="admin-header">

          <div>
            <h2>Shop Owner Panel</h2>
          </div>

          <div className="admin-user">
            <span>Welcome, {user?.name}</span>
          </div>

        </header>

        <section className="admin-content">
          <Outlet />
        </section>

      </main>

    </div>
  );
};

export default ShopOwnerLayout;