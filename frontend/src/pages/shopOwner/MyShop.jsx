import { useState } from "react";

import api from "../../api/client";
import { useApi } from "../../lib/useApi";

const MyShop = () => {
  // GET /api/shop-owner/shop -> the owner's own shop (backend resolves it from
  // the JWT; there is no shop id to pass or tamper with).
  const { data: shop, loading, error, reload } = useApi("/api/shop-owner/shop");

  const [busy, setBusy] = useState(false);
  const [actionError, setActionError] = useState("");

  // PATCH /api/shop-owner/shop/toggle -> OPEN <-> CLOSED
  const handleToggle = async () => {
    setBusy(true);
    setActionError("");
    try {
      await api.patch("/api/shop-owner/shop/toggle");
      await reload();
    } catch (e) {
      setActionError(e.message || "Could not update the shop status.");
    } finally {
      setBusy(false);
    }
  };

  if (loading) {
    return (
      <div className="my-shop-page">
        <p className="empty-message">Loading your shop...</p>
      </div>
    );
  }

  if (error || !shop) {
    return (
      <div className="my-shop-page">
        <div className="empty-message">
          <h2>No shop found</h2>
          <p>{error || "There is no shop assigned to your account yet."}</p>
        </div>
      </div>
    );
  }

  const isOpen = shop.availability === "OPEN";

  return (
    <div className="my-shop-page">

      <div className="page-title shop-page-header">
        <div>
          <h1>My Shop</h1>

          <p>
            Manage your shop information.
          </p>
        </div>

        <button
          className="primary-button"
          onClick={handleToggle}
          disabled={busy}
        >
          {busy ? "Updating..." : isOpen ? "Close Shop" : "Open Shop"}
        </button>
      </div>

      {actionError && <p className="error-message">{actionError}</p>}

      <div className="my-shop-card">

        <div className="shop-header">
          <div>
            <h2>{shop.name}</h2>

            <span
              className={isOpen ? "status-active" : "status-inactive"}
            >
              {isOpen ? "Open" : "Closed"}
            </span>
          </div>
        </div>

        <div className="shop-details">

          <div className="shop-detail">
            <span>Owner Name</span>
            <strong>{shop.shopOwnerName || "—"}</strong>
          </div>

          <div className="shop-detail">
            <span>Email</span>
            <strong>{shop.shopOwnerEmail || "—"}</strong>
          </div>

          <div className="shop-detail">
            <span>Phone</span>
            <strong>{shop.phone || "—"}</strong>
          </div>

          <div className="shop-detail">
            <span>Address</span>
            <strong>{shop.address || "—"}</strong>
          </div>

          <div className="shop-detail">
            <span>Description</span>
            <strong>{shop.description || "—"}</strong>
          </div>

        </div>

      </div>

    </div>
  );
};

export default MyShop;
