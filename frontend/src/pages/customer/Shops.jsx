import { useState } from "react";
import { useNavigate } from "react-router-dom";

import { useApi } from "../../lib/useApi";

const Shops = () => {
  const [search, setSearch] = useState("");
  const navigate = useNavigate();

  // GET /api/customer/shops -> ShopDTO[]
  // Polled so a shop owner flipping OPEN/CLOSED reflects here without a refresh.
  const { data, loading, error } = useApi("/api/customer/shops", {
    pollMs: 10000,
  });

  const shops = data || [];
  const searchText = search.trim().toLowerCase();

  const filteredShops = shops.filter((shop) => {
    if (!searchText) return true;
    return (
      (shop.name || "").toLowerCase().includes(searchText) ||
      (shop.address || "").toLowerCase().includes(searchText) ||
      (shop.description || "").toLowerCase().includes(searchText)
    );
  });

  return (
    <div className="shops-page">

      {/* PAGE HEADER */}

      <div className="page-title">

        <h1>Q-Free Shops</h1>

        <p>
          Explore shops and find your favourite food.
        </p>

      </div>


      {/* SEARCH */}

      <div className="search-box">

        <input
          type="text"
          placeholder="Search shops or locations..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
        />

      </div>

      {error && <p className="error-message">{error}</p>}


      {/* SHOP LIST */}

      {loading ? (

        <p className="empty-message">Loading shops...</p>

      ) : filteredShops.length === 0 ? (

        <div className="empty-message">

          <h2>No shops found</h2>

          <p>
            Try searching for another shop or location.
          </p>

        </div>

      ) : (

        <div className="shop-grid">

          {filteredShops.map((shop) => (

            <div
              className="customer-shop-card"
              key={shop.id}
            >

              <div className="shop-card-content">

                <div className="shop-card-title">

                  <h3>
                    {shop.name}
                  </h3>

                  <span
                    className={
                      shop.availability === "OPEN"
                        ? "shop-open"
                        : "shop-closed"
                    }
                  >
                    {shop.availability === "OPEN" ? "Open" : "Closed"}
                  </span>

                </div>


                <p>
                  {shop.address}
                </p>


                <p>
                  {shop.foodItemCount ?? 0} items available
                </p>


                <button
                  className="primary-button shop-view-button"
                  disabled={shop.availability !== "OPEN"}
                  onClick={() =>
                    navigate(`/customer/shops/${shop.id}`)
                  }
                >
                  {shop.availability === "OPEN"
                    ? "View Food"
                    : "Shop Closed"}
                </button>

              </div>

            </div>

          ))}

        </div>

      )}

    </div>
  );
};

export default Shops;
