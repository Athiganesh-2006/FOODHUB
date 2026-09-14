import { NavLink, Outlet, useNavigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import logo from "../assets/q-free-logo.png";
const AdminLayout = () => {
  const { user, logout } = useAuth();
  const navigate = useNavigate();

  const handleLogout = () => {
    logout();
    navigate("/login");
  };

  return (
    <div className="admin-layout">

      {/* Sidebar */}
      <aside className="admin-sidebar">

        <div className="sidebar-logo">
  <img
    src={logo}
    alt="Q-Free"
    className="sidebar-logo-image"
  />
</div>

        <nav className="sidebar-menu">

          <NavLink to="/admin/dashboard">
            Dashboard
          </NavLink>

          <NavLink to="/admin/customers">
            Customers
          </NavLink>

          <NavLink to="/admin/shops">
            Shops
          </NavLink>

          <NavLink to="/admin/users">
            Shop Owners
          </NavLink>

          <NavLink to="/admin/profile">
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

      {/* Main Content */}
      <main className="admin-main">

        <header className="admin-header">

          <div>
            <h2>Admin Panel</h2>
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

export default AdminLayout;