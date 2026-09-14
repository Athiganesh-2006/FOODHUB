import { useState } from "react";

import api from "../../api/client";
import { useApi } from "../../lib/useApi";

// Mirrors the backend CreateShopRequest.
const emptyForm = {
  name: "",
  description: "",
  address: "",
  phone: "",
  shopOwnerId: "",
  availability: "OPEN",
};

const Shops = () => {
  // GET /api/admin/shops and /api/admin/shop-owners
  const { data, loading, error, reload } = useApi("/api/admin/shops");
  const { data: ownersData } = useApi("/api/admin/shop-owners");

  const shops = data || [];
  const owners = ownersData || [];

  const [search, setSearch] = useState("");
  const [showForm, setShowForm] = useState(false);
  const [editingShop, setEditingShop] = useState(null);
  const [formData, setFormData] = useState(emptyForm);
  const [saving, setSaving] = useState(false);
  const [actionError, setActionError] = useState("");

  const searchText = search.trim().toLowerCase();

  const filteredShops = shops.filter((shop) => {
    if (!searchText) return true;
    return (
      (shop.name || "").toLowerCase().includes(searchText) ||
      (shop.shopOwnerName || "").toLowerCase().includes(searchText) ||
      (shop.address || "").toLowerCase().includes(searchText)
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
    setEditingShop(null);
    setFormData(emptyForm);
    setActionError("");
    setShowForm(true);
  };

  const handleEdit = (shop) => {
    setEditingShop(shop);

    setFormData({
      name: shop.name || "",
      description: shop.description || "",
      address: shop.address || "",
      phone: shop.phone || "",
      shopOwnerId: shop.shopOwnerId ? String(shop.shopOwnerId) : "",
      availability: shop.availability || "OPEN",
    });

    setActionError("");
    setShowForm(true);
  };

  // POST /api/admin/shops  |  PUT /api/admin/shops/{id}
  const handleSubmit = async (e) => {
    e.preventDefault();
    setSaving(true);
    setActionError("");

    const payload = {
      name: formData.name,
      description: formData.description,
      address: formData.address,
      phone: formData.phone,
      shopOwnerId: formData.shopOwnerId
        ? Number(formData.shopOwnerId)
        : null,
      availability: formData.availability,
    };

    try {
      if (editingShop) {
        await api.put(`/api/admin/shops/${editingShop.id}`, payload);
      } else {
        await api.post("/api/admin/shops", payload);
      }
      await reload();
      handleCloseForm();
    } catch (err) {
      setActionError(err.message || "Could not save this shop.");
    } finally {
      setSaving(false);
    }
  };

  // DELETE /api/admin/shops/{id}
  const handleDelete = async (id) => {
    const confirmDelete = window.confirm(
      "Are you sure you want to delete this shop?",
    );

    if (!confirmDelete) {
      return;
    }

    setActionError("");
    try {
      await api.delete(`/api/admin/shops/${id}`);
      await reload();
    } catch (err) {
      setActionError(err.message || "Could not delete this shop.");
    }
  };

  const handleView = (shop) => {
    window.alert(
      `Shop Details\n\n` +
        `Shop Name: ${shop.name}\n` +
        `Owner: ${shop.shopOwnerName || "—"}\n` +
        `Email: ${shop.shopOwnerEmail || "—"}\n` +
        `Phone: ${shop.phone || "—"}\n` +
        `Address: ${shop.address || "—"}\n` +
        `Status: ${shop.availability}`,
    );
  };

  const handleCloseForm = () => {
    setShowForm(false);
    setEditingShop(null);
    setFormData(emptyForm);
  };

  return (
    <div className="shops-page">

      <div className="page-header">

        <div>
          <h1>Shops</h1>
          <p>Manage Q-Free shops.</p>
        </div>

        <button
          className="primary-button"
          onClick={handleAdd}
        >
          + Add Shop
        </button>

      </div>

      <div className="search-box">

        <input
          type="text"
          placeholder="Search shops by name, owner or address..."
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
              <th>Shop Name</th>
              <th>Owner</th>
              <th>Owner Email</th>
              <th>Phone</th>
              <th>Address</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>

          <tbody>

            {loading ? (

              <tr>
                <td colSpan="7" className="empty-message">
                  Loading shops...
                </td>
              </tr>

            ) : filteredShops.length > 0 ? (
              filteredShops.map((shop) => (

                <tr key={shop.id}>

                  <td>{shop.name}</td>

                  <td>{shop.shopOwnerName || "—"}</td>

                  <td>{shop.shopOwnerEmail || "—"}</td>

                  <td>{shop.phone || "—"}</td>

                  <td>{shop.address || "—"}</td>

                  <td>
                    <span
                      className={
                        shop.availability === "OPEN"
                          ? "status-active"
                          : "status-inactive"
                      }
                    >
                      {shop.availability === "OPEN" ? "Open" : "Closed"}
                    </span>
                  </td>

                  <td>

                    <div className="table-actions">

                      <button
                        className="view-button"
                        onClick={() => handleView(shop)}
                      >
                        View
                      </button>

                      <button
                        className="edit-button"
                        onClick={() => handleEdit(shop)}
                      >
                        Edit
                      </button>

                      <button
                        className="delete-button"
                        onClick={() => handleDelete(shop.id)}
                      >
                        Delete
                      </button>

                    </div>

                  </td>

                </tr>

              ))
            ) : (

              <tr>
                <td colSpan="7" className="empty-message">
                  No shops found.
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

              <h2>
                {editingShop
                  ? "Edit Shop"
                  : "Add Shop"}
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
                <label>Shop Name</label>

                <input
                  type="text"
                  name="name"
                  placeholder="Enter shop name"
                  value={formData.name}
                  onChange={handleChange}
                  required
                />
              </div>

              <div className="form-group">
                <label>Shop Owner</label>

                <select
                  name="shopOwnerId"
                  value={formData.shopOwnerId}
                  onChange={handleChange}
                  required={!editingShop}
                >
                  <option value="">Select a shop owner</option>

                  {owners.map((owner) => (
                    <option value={owner.id} key={owner.id}>
                      {owner.name} ({owner.email})
                    </option>
                  ))}
                </select>
              </div>

              <div className="form-group">
                <label>Description</label>

                <input
                  type="text"
                  name="description"
                  placeholder="Enter shop description"
                  value={formData.description}
                  onChange={handleChange}
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
                  placeholder="Enter shop address"
                  value={formData.address}
                  onChange={handleChange}
                  required
                />
              </div>

              <div className="form-group">
                <label>Status</label>

                <select
                  name="availability"
                  value={formData.availability}
                  onChange={handleChange}
                >
                  <option value="OPEN">
                    Open
                  </option>

                  <option value="CLOSED">
                    Closed
                  </option>
                </select>
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
                    : editingShop
                    ? "Save Changes"
                    : "Add Shop"}
                </button>

              </div>

            </form>

          </div>

        </div>

      )}

    </div>
  );
};

export default Shops;
