import { useState } from "react";

import api from "../../api/client";
import { useApi } from "../../lib/useApi";
import { FOOD_CATEGORIES, inr, prettyCategory } from "../../lib/format";

// Mirrors the backend CreateFoodRequest.
const emptyForm = {
  name: "",
  category: "BREAKFAST",
  price: "",
  description: "",
  prepTimeMinutes: "15",
  availability: "true",
};

const FoodItems = () => {
  // GET /api/shop-owner/foods — only this owner's shop, resolved from the JWT.
  const { data, loading, error, reload } = useApi("/api/shop-owner/foods");
  const foodItems = data || [];

  const [search, setSearch] = useState("");
  const [showForm, setShowForm] = useState(false);
  const [editingFood, setEditingFood] = useState(null);
  const [formData, setFormData] = useState(emptyForm);
  const [saving, setSaving] = useState(false);
  const [actionError, setActionError] = useState("");

  const searchText = search.trim().toLowerCase();

  const filteredFoodItems = foodItems.filter((food) => {
    if (!searchText) return true;
    return (
      (food.name || "").toLowerCase().includes(searchText) ||
      (food.category || "").toLowerCase().includes(searchText)
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
    setEditingFood(null);
    setFormData(emptyForm);
    setActionError("");
    setShowForm(true);
  };

  const handleEdit = (food) => {
    setEditingFood(food);

    setFormData({
      name: food.name || "",
      category: food.category || "BREAKFAST",
      price: String(food.price ?? ""),
      description: food.description || "",
      prepTimeMinutes: String(food.prepTimeMinutes ?? 15),
      availability: food.availability ? "true" : "false",
    });

    setActionError("");
    setShowForm(true);
  };

  // POST /api/shop-owner/foods  |  PUT /api/shop-owner/foods/{id}
  const handleSubmit = async (e) => {
    e.preventDefault();
    setSaving(true);
    setActionError("");

    const payload = {
      name: formData.name,
      description: formData.description,
      price: Number(formData.price),
      category: formData.category,
      // Canonical local image path, matching how the backend seeds imageUrl.
      imageUrl:
        editingFood?.imageUrl ||
        "/images/foods/" +
          formData.name
            .toLowerCase()
            .replace(/[^a-z0-9]+/g, "-")
            .replace(/(^-|-$)/g, "") +
          ".png",
      availability: formData.availability === "true",
      prepTimeMinutes: Number(formData.prepTimeMinutes),
    };

    try {
      if (editingFood) {
        await api.put(`/api/shop-owner/foods/${editingFood.id}`, payload);
      } else {
        await api.post("/api/shop-owner/foods", payload);
      }
      await reload();
      handleCloseForm();
    } catch (err) {
      setActionError(err.message || "Could not save this food item.");
    } finally {
      setSaving(false);
    }
  };

  // DELETE /api/shop-owner/foods/{id}
  const handleDelete = async (id) => {
    const confirmDelete = window.confirm(
      "Are you sure you want to delete this food item?",
    );

    if (!confirmDelete) {
      return;
    }

    setActionError("");
    try {
      await api.delete(`/api/shop-owner/foods/${id}`);
      await reload();
    } catch (err) {
      setActionError(err.message || "Could not delete this food item.");
    }
  };

  // PATCH /api/shop-owner/foods/{id}/toggle
  const handleToggle = async (id) => {
    setActionError("");
    try {
      await api.patch(`/api/shop-owner/foods/${id}/toggle`);
      await reload();
    } catch (err) {
      setActionError(err.message || "Could not change availability.");
    }
  };

  const handleCloseForm = () => {
    setShowForm(false);
    setEditingFood(null);
    setFormData(emptyForm);
  };

  return (
    <div className="food-items-page">

      <div className="page-header">

        <div>
          <h1>Food Items</h1>
          <p>Manage the food items in your shop.</p>
        </div>

        <button
          className="primary-button"
          onClick={handleAdd}
        >
          + Add Food
        </button>

      </div>

      <div className="search-box">

        <input
          type="text"
          placeholder="Search food by name or category..."
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
              <th>Food Name</th>
              <th>Category</th>
              <th>Price</th>
              <th>Prep Time</th>
              <th>Description</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>

          <tbody>

            {loading ? (

              <tr>
                <td colSpan="7" className="empty-message">
                  Loading food items...
                </td>
              </tr>

            ) : filteredFoodItems.length > 0 ? (
              filteredFoodItems.map((food) => (

                <tr key={food.id}>

                  <td>{food.name}</td>

                  <td>{prettyCategory(food.category)}</td>

                  <td>{inr(food.price)}</td>

                  <td>{food.prepTimeMinutes ?? "—"} min</td>

                  <td>{food.description}</td>

                  <td>
                    <span
                      className={
                        food.availability
                          ? "status-active"
                          : "status-inactive"
                      }
                    >
                      {food.availability ? "Available" : "Unavailable"}
                    </span>
                  </td>

                  <td>

                    <div className="table-actions">

                      <button
                        className="view-button"
                        onClick={() => handleToggle(food.id)}
                      >
                        {food.availability ? "Disable" : "Enable"}
                      </button>

                      <button
                        className="edit-button"
                        onClick={() => handleEdit(food)}
                      >
                        Edit
                      </button>

                      <button
                        className="delete-button"
                        onClick={() => handleDelete(food.id)}
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
                  colSpan="7"
                  className="empty-message"
                >
                  No food items found.
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
                {editingFood
                  ? "Edit Food"
                  : "Add Food"}
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
                <label>Food Name</label>

                <input
                  type="text"
                  name="name"
                  placeholder="Enter food name"
                  value={formData.name}
                  onChange={handleChange}
                  required
                />
              </div>

              <div className="form-group">
                <label>Category</label>

                <select
                  name="category"
                  value={formData.category}
                  onChange={handleChange}
                >
                  {FOOD_CATEGORIES.map((c) => (
                    <option value={c} key={c}>
                      {prettyCategory(c)}
                    </option>
                  ))}
                </select>
              </div>

              <div className="form-group">
                <label>Price (₹)</label>

                <input
                  type="number"
                  name="price"
                  placeholder="Enter price"
                  value={formData.price}
                  onChange={handleChange}
                  min="1"
                  step="0.01"
                  required
                />
              </div>

              <div className="form-group">
                <label>Preparation Time (minutes)</label>

                <input
                  type="number"
                  name="prepTimeMinutes"
                  placeholder="e.g. 15"
                  value={formData.prepTimeMinutes}
                  onChange={handleChange}
                  min="1"
                  required
                />
              </div>

              <div className="form-group">
                <label>Description</label>

                <input
                  type="text"
                  name="description"
                  placeholder="Enter food description"
                  value={formData.description}
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
                  <option value="true">
                    Available
                  </option>

                  <option value="false">
                    Unavailable
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
                    : editingFood
                    ? "Save Changes"
                    : "Add Food"}
                </button>

              </div>

            </form>

          </div>

        </div>

      )}

    </div>
  );
};

export default FoodItems;
