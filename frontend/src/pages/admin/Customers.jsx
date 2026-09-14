import { useState } from "react";

import api from "../../api/client";
import { useApi } from "../../lib/useApi";

// Mirrors the backend CreateUserRequest (role is fixed to CUSTOMER server-side).
const emptyForm = {
  name: "",
  email: "",
  password: "",
  phone: "",
  address: "",
};

const Customers = () => {
  // GET /api/admin/customers -> UserDTO[]
  const { data, loading, error, reload } = useApi("/api/admin/customers");
  const customers = data || [];

  const [search, setSearch] = useState("");
  const [showForm, setShowForm] = useState(false);
  const [editingCustomer, setEditingCustomer] = useState(null);
  const [formData, setFormData] = useState(emptyForm);
  const [saving, setSaving] = useState(false);
  const [actionError, setActionError] = useState("");

  const searchText = search.trim().toLowerCase();

  const filteredCustomers = customers.filter((customer) => {
    if (!searchText) return true;
    return (
      (customer.name || "").toLowerCase().includes(searchText) ||
      (customer.email || "").toLowerCase().includes(searchText) ||
      (customer.phone || "").includes(searchText)
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
    setEditingCustomer(null);
    setFormData(emptyForm);
    setActionError("");
    setShowForm(true);
  };

  const handleEdit = (customer) => {
    setEditingCustomer(customer);

    setFormData({
      name: customer.name || "",
      email: customer.email || "",
      password: "",
      phone: customer.phone || "",
      address: customer.address || "",
    });

    setActionError("");
    setShowForm(true);
  };

  // POST /api/admin/customers  |  PUT /api/admin/customers/{id}
  const handleSubmit = async (e) => {
    e.preventDefault();
    setSaving(true);
    setActionError("");

    try {
      if (editingCustomer) {
        // The backend ignores email changes and only re-hashes the password
        // when a non-blank one is sent.
        await api.put(`/api/admin/customers/${editingCustomer.id}`, {
          name: formData.name,
          phone: formData.phone,
          address: formData.address,
          password: formData.password || null,
        });
      } else {
        await api.post("/api/admin/customers", {
          name: formData.name,
          email: formData.email,
          password: formData.password,
          phone: formData.phone,
          address: formData.address,
          role: "CUSTOMER",
        });
      }
      await reload();
      handleCloseForm();
    } catch (err) {
      setActionError(err.message || "Could not save this customer.");
    } finally {
      setSaving(false);
    }
  };

  // DELETE /api/admin/customers/{id}
  const handleDelete = async (id) => {
    const confirmDelete = window.confirm(
      "Are you sure you want to delete this customer?",
    );

    if (!confirmDelete) {
      return;
    }

    setActionError("");
    try {
      await api.delete(`/api/admin/customers/${id}`);
      await reload();
    } catch (err) {
      setActionError(err.message || "Could not delete this customer.");
    }
  };

  const handleView = (customer) => {
    window.alert(
      `Customer Details\n\n` +
        `Name: ${customer.name}\n` +
        `Email: ${customer.email}\n` +
        `Phone: ${customer.phone || "—"}\n` +
        `Address: ${customer.address || "—"}`,
    );
  };

  const handleCloseForm = () => {
    setShowForm(false);
    setEditingCustomer(null);
    setFormData(emptyForm);
  };

  return (
    <div className="customers-page">

      {/* Page Header */}
      <div className="page-header">

        <div>
          <h1>Customers</h1>
          <p>Manage Q-Free customers.</p>
        </div>

        <button
          className="primary-button"
          onClick={handleAdd}
        >
          + Add Customer
        </button>

      </div>

      {/* Search */}
      <div className="search-box">

        <input
          type="text"
          placeholder="Search customers by name, email or phone..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
        />

      </div>

      {(error || actionError) && (
        <p className="error-message">{actionError || error}</p>
      )}

      {/* Customer Table */}
      <div className="table-container">

        <table>

          <thead>
            <tr>
              <th>Name</th>
              <th>Email</th>
              <th>Phone</th>
              <th>Address</th>
              <th>Actions</th>
            </tr>
          </thead>

          <tbody>

            {loading ? (

              <tr>
                <td colSpan="5" className="empty-message">
                  Loading customers...
                </td>
              </tr>

            ) : filteredCustomers.length > 0 ? (
              filteredCustomers.map((customer) => (

                <tr key={customer.id}>

                  <td>{customer.name}</td>

                  <td>{customer.email}</td>

                  <td>{customer.phone || "—"}</td>

                  <td>{customer.address || "—"}</td>

                  <td>

                    <div className="table-actions">

                      <button
                        className="view-button"
                        onClick={() => handleView(customer)}
                      >
                        View
                      </button>

                      <button
                        className="edit-button"
                        onClick={() => handleEdit(customer)}
                      >
                        Edit
                      </button>

                      <button
                        className="delete-button"
                        onClick={() => handleDelete(customer.id)}
                      >
                        Delete
                      </button>

                    </div>

                  </td>

                </tr>

              ))
            ) : (

              <tr>
                <td
                  colSpan="5"
                  className="empty-message"
                >
                  No customers found.
                </td>
              </tr>

            )}

          </tbody>

        </table>

      </div>

      {/* Add / Edit Customer Modal */}
      {showForm && (

        <div className="modal-overlay">

          <div className="modal">

            <div className="modal-header">

              <h2>
                {editingCustomer
                  ? "Edit Customer"
                  : "Add Customer"}
              </h2>

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
                  placeholder="Enter customer name"
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
                  disabled={!!editingCustomer}
                  required
                />

              </div>

              <div className="form-group">

                <label>
                  {editingCustomer
                    ? "New Password (leave blank to keep)"
                    : "Password"}
                </label>

                <input
                  type="password"
                  name="password"
                  placeholder={
                    editingCustomer
                      ? "Leave blank to keep the current password"
                      : "Enter a password"
                  }
                  value={formData.password}
                  onChange={handleChange}
                  autoComplete="new-password"
                  required={!editingCustomer}
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
                  {saving
                    ? "Saving..."
                    : editingCustomer
                    ? "Save Changes"
                    : "Add Customer"}
                </button>

              </div>

            </form>

          </div>

        </div>

      )}

    </div>
  );
};

export default Customers;
