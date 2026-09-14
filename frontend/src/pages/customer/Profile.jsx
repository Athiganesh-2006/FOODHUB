import { useAuth } from "../../context/AuthContext";
import { ROLE_LABELS } from "../../lib/roles";

const Profile = () => {
  // The user object is the `user` half of the JWT login response.
  const { user } = useAuth();

  return (
    <div className="customer-profile-page">

      <div className="page-title">
        <h1>My Profile</h1>
        <p>View your Q-Free account details.</p>
      </div>

      <div className="profile-card">

        <div className="profile-header">

          <div className="profile-avatar">
            {user?.name?.charAt(0).toUpperCase()}
          </div>

          <div>
            <h2>{user?.name}</h2>
            <span className="profile-role">
              {user?.role}
            </span>
          </div>

        </div>

        <div className="profile-details">

          <div className="profile-detail">
            <span>Name</span>
            <strong>
              {user?.name || "Not available"}
            </strong>
          </div>

          <div className="profile-detail">
            <span>Email</span>
            <strong>
              {user?.email || "Not available"}
            </strong>
          </div>

          <div className="profile-detail">
            <span>Phone</span>
            <strong>
              {user?.phone || "Not available"}
            </strong>
          </div>

          <div className="profile-detail">
            <span>Address</span>
            <strong>
              {user?.address || "Not available"}
            </strong>
          </div>

          <div className="profile-detail">
            <span>Role</span>
            <strong>
              {ROLE_LABELS[user?.role] || user?.role}
            </strong>
          </div>

        </div>

      </div>

    </div>
  );
};

export default Profile;
