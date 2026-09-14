import { useAuth } from "../../context/AuthContext";
import { ROLE_LABELS } from "../../lib/roles";

const Profile = () => {
  // The user object is the `user` half of the JWT login response.
  const { user } = useAuth();

  return (
    <div className="profile-page">

      <div className="page-title">
        <h1>My Profile</h1>
        <p>View your Q-Free administrator details.</p>
      </div>

      <div className="profile-card">

        <div className="profile-avatar">
          {user?.name?.charAt(0).toUpperCase()}
        </div>

        <div className="profile-details">

          <div className="profile-row">
            <span>Name</span>
            <strong>{user?.name}</strong>
          </div>

          <div className="profile-row">
            <span>Email</span>
            <strong>{user?.email}</strong>
          </div>

          <div className="profile-row">
            <span>Phone</span>
            <strong>{user?.phone || "—"}</strong>
          </div>

          <div className="profile-row">
            <span>Role</span>
            <strong>{ROLE_LABELS[user?.role] || user?.role}</strong>
          </div>

        </div>

      </div>

    </div>
  );
};

export default Profile;
