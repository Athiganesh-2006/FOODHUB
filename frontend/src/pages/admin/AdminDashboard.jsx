import { useNavigate } from "react-router-dom";
import { useApi } from "../../lib/useApi";

const AdminDashboard = () => {
  const navigate = useNavigate();

  // GET /api/admin/dashboard -> DashboardStatsDTO
  const { data, loading, error } = useApi("/api/admin/dashboard");

  const stats = [
    {
      title: "Total Customers",
      value: data?.totalCustomers ?? "—",
      path: "/admin/customers",
    },
    {
      title: "Total Shops",
      value: data?.totalShops ?? "—",
      path: "/admin/shops",
    },
    {
      title: "Shop Owners",
      value: data?.totalShopOwners ?? "—",
      path: "/admin/users",
    },
    {
      // The backend exposes the count only — there is no admin order listing
      // endpoint, so this card does not navigate anywhere.
      title: "Total Orders",
      value: data?.totalOrders ?? "—",
      path: null,
    },
  ];

  return (
    <div className="dashboard-page">

      <div className="page-title">
        <h1>Dashboard</h1>
        <p>Here's what's happening in Q-Free.</p>
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
              onClick={() => {
                if (stat.path) {
                  navigate(stat.path);
                }
              }}
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
        <h2>Welcome to Q-Free Admin</h2>

        <p>
          Use the sidebar to manage customers,
          shops, and shop owners.
        </p>
      </div>

    </div>
  );
};

export default AdminDashboard;
