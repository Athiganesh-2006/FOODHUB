import {
  BrowserRouter,
  Routes,
  Route,
  Navigate,
} from "react-router-dom";

// Login
import Login from "./pages/Login";

// Layouts
import AdminLayout from "./components/AdminLayout";
import ShopOwnerLayout from "./components/ShopOwnerLayout";
import CustomerLayout from "./components/CustomerLayout";

// Admin Pages
import AdminDashboard from "./pages/admin/AdminDashboard";
import Customers from "./pages/admin/Customers";
import Shops from "./pages/admin/Shops";
import Users from "./pages/admin/Users";
import AdminProfile from "./pages/admin/Profile";

// Shop Owner Pages
import OwnerDashboard from "./pages/shopOwner/OwnerDashboard";
import MyShop from "./pages/shopOwner/MyShop";
import FoodItems from "./pages/shopOwner/FoodItems";
import ShopOwnerOrders from "./pages/shopOwner/Orders";
import OwnerProfile from "./pages/shopOwner/Profile";

// Customer Pages
import CustomerHome from "./pages/customer/CustomerHome";
import CustomerShops from "./pages/customer/Shops";
import ShopFood from "./pages/customer/ShopFood";
import Cart from "./pages/customer/Cart";
import Checkout from "./pages/customer/Checkout";
import Payment from "./pages/customer/Payment";
import PaymentSuccess from "./pages/customer/PaymentSuccess";
import CustomerOrders from "./pages/customer/Orders";
import CustomerProfile from "./pages/customer/Profile";

// Protected Route
import ProtectedRoute from "./routes/ProtectedRoute";

const App = () => {
  return (
    <BrowserRouter>
      <Routes>

        {/* ==================================================
            LOGIN
        ================================================== */}

        <Route
          path="/login"
          element={<Login />}
        />


        {/* ==================================================
            ADMIN
        ================================================== */}

        <Route
          path="/admin"
          element={
            <ProtectedRoute allowedRole="ADMIN">
              <AdminLayout />
            </ProtectedRoute>
          }
        >

          <Route
            index
            element={
              <Navigate
                to="dashboard"
                replace
              />
            }
          />

          <Route
            path="dashboard"
            element={<AdminDashboard />}
          />

          <Route
            path="customers"
            element={<Customers />}
          />

          <Route
            path="shops"
            element={<Shops />}
          />

          <Route
            path="users"
            element={<Users />}
          />

          <Route
            path="profile"
            element={<AdminProfile />}
          />

        </Route>


        {/* ==================================================
            SHOP OWNER
        ================================================== */}

        <Route
          path="/shop-owner"
          element={
            <ProtectedRoute allowedRole="SHOP_OWNER">
              <ShopOwnerLayout />
            </ProtectedRoute>
          }
        >

          <Route
            index
            element={
              <Navigate
                to="dashboard"
                replace
              />
            }
          />

          <Route
            path="dashboard"
            element={<OwnerDashboard />}
          />

          <Route
            path="shop"
            element={<MyShop />}
          />

          <Route
            path="food-items"
            element={<FoodItems />}
          />

          <Route
            path="orders"
            element={<ShopOwnerOrders />}
          />

          <Route
            path="profile"
            element={<OwnerProfile />}
          />

        </Route>


        {/* ==================================================
            CUSTOMER
        ================================================== */}

        <Route
          path="/customer"
          element={
            <ProtectedRoute allowedRole="CUSTOMER">
              <CustomerLayout />
            </ProtectedRoute>
          }
        >

          {/* Customer Default */}

          <Route
            index
            element={
              <Navigate
                to="home"
                replace
              />
            }
          />


          {/* Customer Home */}

          <Route
            path="home"
            element={<CustomerHome />}
          />


          {/* Customer Shops */}

          <Route
            path="shops"
            element={<CustomerShops />}
          />


          {/* Food inside selected shop */}

          <Route
            path="shops/:shopId"
            element={<ShopFood />}
          />


          {/* Customer Cart */}

          <Route
            path="cart"
            element={<Cart />}
          />


          {/* Customer Checkout */}

          <Route
            path="checkout"
            element={<Checkout />}
          />


          {/* Customer Payment */}

          <Route
            path="payment"
            element={<Payment />}
          />


          {/* Payment Success */}

          <Route
            path="payment-success"
            element={<PaymentSuccess />}
          />


          {/* Customer Orders */}

          <Route
            path="orders"
            element={<CustomerOrders />}
          />


          {/* Customer Profile */}

          <Route
            path="profile"
            element={<CustomerProfile />}
          />

        </Route>


        {/* ==================================================
            DEFAULT ROUTES
        ================================================== */}

        <Route
          path="/"
          element={
            <Navigate
              to="/login"
              replace
            />
          }
        />

        <Route
          path="*"
          element={
            <Navigate
              to="/login"
              replace
            />
          }
        />

      </Routes>
    </BrowserRouter>
  );
};

export default App;
