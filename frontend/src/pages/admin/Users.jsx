import { useState } from "react";

import api from "../../api/client";
import { useApi } from "../../lib/useApi";

// Mirrors the backend CreateUserRequest (role is fixed to SHOP_OWNER server-side).
const emptyForm = {
  name: "",
  email: "",
  password: "",
  phone: "",
  address: "",
};

/**
 * Shop owners. The backend exposes GET and POST /api/admin/shop-owners only —
 * there is no update or delete endpoint for shop owners, so this page does not
 * offer those actions rather than calling something that does not exist.
 */
const Users = () => {
  const { data, loading, error, reload } = useApi("/api/admin/shop-owners");
  const owners = data || [];

  const [search, setSearch] = useState("");
  const [showForm, setShowForm] = useState(false);
  const [formData, setFormData] = useState(emptyForm);
  const [saving, setSaving] = useState(false);
  const [actionError, setActionError] = useState("");

  const searchText = search.trim().toLowerCase();

  const filteredUsers = owners.filter((user) => {
    if (!searchText) return true;
    return (
      (user.name || "").toLowerCase().includes(searchText) ||
      (user.email || "").toLowerCase().includes(searchText)
    );
  });

  const handleChange = (e) => {
    const { name, value } = e.target;

    setFormData({
      ...formData,
      [name]: value,
    });
  };

  const handleAdd = () => {
    setFormData(emptyForm);
    setActionError("");
    setShowForm(true);
  };

  // POST /api/admin/shop-owners
  const handleSubmit = async (e) => {
    e.preventDefault();
    setSaving(true);
    setActionError("");

    try {
      await api.post("/api/admin/shop-owners", {
        name: formData.name,
        email: formData.email,
        password: formData.password,
        phone: formData.phone,
        address: formData.address,
        role: "SHOP_OWNER",
      });
      await reload();
      handleCloseForm();
    } catch (err) {
      setActionError(err.message || "Could not create this shop owner.");
    } finally {
      setSaving(false);
    }
  };

  const handleView = (user) => {
    window.alert(
      `Shop Owner Details\n\n` +
        `Name: ${user.name}\n` +
        `Email: ${user.email}\n` +
        `Phone: ${user.phone || "—"}\n` +
        `Address: ${user.address || "—"}\n` +
        `Role: ${user.role}`,
    );
  };

  const handleCloseForm = () => {
    setShowForm(false);
    setFormData(emptyForm);
  };

  return (
    <div className="users-page">

      <div className="page-header">

        <div>
          <h1>Shop Owners</h1>
          <p>Manage the shop owner accounts.</p>
        </div>

        <button
          className="primary-button"
          onClick={handleAdd}
        >
          + Add Shop Owner
        </button>

      </div>

      <div className="search-box">

        <input
          type="text"
          placeholder="Search shop owners by name or email..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
        />

      </div>

      {(error || actionError) && (
        <p className="error-message">{actionError || error}</p>
      )}

      <div className="table-container">

        <table>

          <thead>
            <tr>
              <th>Name</th>
              <th>Email</th>
              <th>Phone</th>
              <th>Address</th>
              <th>Role</th>
              <th>Actions</th>
            </tr>
          </thead>

          <tbody>

            {loading ? (

              <tr>
                <td colSpan="6" className="empty-message">
                  Loading shop owners...
                </td>
              </tr>

            ) : filteredUsers.length > 0 ? (
              filteredUsers.map((user) => (

                <tr key={user.id}>

                  <td>{user.name}</td>

                  <td>{user.email}</td>

                  <td>{user.phone || "—"}</td>

                  <td>{user.address || "—"}</td>

                  <td>
                    <span className="role-badge">
                      {user.role}
                    </span>
                  </td>

                  <td>

                    <div className="table-actions">

                      <button
                        className="view-button"
                        onClick={() => handleView(user)}
                      >
                        View
                      </button>

                    </div>

                  </td>

                </tr>

              ))
            ) : (

              <tr>
                <td colSpan="6" className="empty-message">
                  No shop owners found.
                </td>
              </tr>

            )}

          </tbody>

        </table>

      </div>

      {showForm && (

        <div className="modal-overlay">

          <div className="modal">

            <div className="modal-header">

              <h2>Add Shop Owner</h2>

              <button
                className="close-button"
                onClick={handleCloseForm}
              >
                ×
              </button>

            </div>

            <form onSubmit={handleSubmit}>

              <div className="form-group">

                <label>Name</label>

                <input
                  type="text"
                  name="name"
                  placeholder="Enter name"
                  value={formData.name}
                  onChange={handleChange}
                  required
                />

              </div>

              <div className="form-group">

                <label>Email</label>

                <input
                  type="email"
                  name="email"
                  placeholder="Enter email"
                  value={formData.email}
                  onChange={handleChange}
                  required
                />

              </div>

              <div className="form-group">

                <label>Password</label>

                <input
                  type="password"
                  name="password"
                  placeholder="Enter a password"
                  value={formData.password}
                  onChange={handleChange}
                  autoComplete="new-password"
                  required
                />

              </div>

              <div className="form-group">

                <label>Phone</label>

                <input
                  type="tel"
                  name="phone"
                  placeholder="Enter phone number"
                  value={formData.phone}
                  onChange={handleChange}
                  required
                />

              </div>

              <div className="form-group">

                <label>Address</label>

                <input
                  type="text"
                  name="address"
                  placeholder="Enter address"
                  value={formData.address}
                  onChange={handleChange}
                  required
                />

              </div>

              {actionError && (
                <p className="error-message">{actionError}</p>
              )}

              <div className="modal-actions">

                <button
                  type="button"
                  className="cancel-button"
                  onClick={handleCloseForm}
                >
                  Cancel
                </button>

                <button
                  type="submit"
                  className="primary-button"
                  disabled={saving}
                >
                  {saving ? "Saving..." : "Add Shop Owner"}
                </button>

              </div>

            </form>

          </div>

        </div>

      )}

    </div>
  );
};

export default Users;
