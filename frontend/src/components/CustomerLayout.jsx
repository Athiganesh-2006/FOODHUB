import { NavLink, Outlet, useNavigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { useCart } from "../context/CartContext";
import logo from "../assets/q-free-logo.png";
const CustomerLayout = () => {
  const { user, logout } = useAuth();
  const { itemCount } = useCart();

  const navigate = useNavigate();
  const cartCount = itemCount;

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

          <NavLink to="/customer/home">
            Home
          </NavLink>

          <NavLink to="/customer/shops">
            Shops
          </NavLink>

          <NavLink to="/customer/cart">
            <span>Cart</span>

            {cartCount > 0 && (
              <span className="cart-count">
                {cartCount}
              </span>
            )}
          </NavLink>

          <NavLink to="/customer/orders">
            Orders
          </NavLink>

          <NavLink to="/customer/profile">
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
            <h2>Q-Free</h2>
          </div>

          <div className="admin-user">
            <span>
              Welcome, {user?.name}
            </span>
          </div>

        </header>

        <section className="admin-content">
          <Outlet />
        </section>

      </main>

    </div>
  );
};

export default CustomerLayout;