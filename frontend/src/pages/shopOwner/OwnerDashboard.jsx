import { useNavigate } from "react-router-dom";
import { useApi } from "../../lib/useApi";

const OwnerDashboard = () => {
  const navigate = useNavigate();

  // GET /api/shop-owner/dashboard -> ShopOwnerDashboardDTO
  const { data, loading, error } = useApi("/api/shop-owner/dashboard");

  const stats = [
    {
      title: "Food Items",
      value: data?.totalFoodItems ?? "—",
      path: "/shop-owner/food-items",
    },
    {
      title: "Available Items",
      value: data?.availableFoodItems ?? "—",
      path: "/shop-owner/food-items",
    },
    {
      title: "Pending Orders",
      value: data?.pendingOrders ?? "—",
      path: "/shop-owner/orders",
    },
    {
      title: "Accepted Orders",
      value: data?.acceptedOrders ?? "—",
      path: "/shop-owner/orders",
    },
  ];

  return (
    <div className="dashboard-page">

      <div className="page-title">
        <h1>Shop Owner Dashboard</h1>

        <p>
          Welcome to your Q-Free shop dashboard.
        </p>
      </div>

      {error && <p className="error-message">{error}</p>}

      {loading ? (

        <p className="empty-message">Loading dashboard...</p>

      ) : (

        <div className="stats-grid">

          {stats.map((stat) => (
            <div
              className="stat-card"
              key={stat.title}
              onClick={() => navigate(stat.path)}
            >
              <div className="stat-content">

                <p>{stat.title}</p>

                <h2>{stat.value}</h2>

              </div>
            </div>
          ))}

        </div>

      )}

      <div className="dashboard-welcome">

        <h2>Welcome, Shop Owner</h2>

        <p>
          Manage your shop, food items, and customer
          orders using the sidebar.
        </p>

      </div>

    </div>
  );
};

export default OwnerDashboard;
