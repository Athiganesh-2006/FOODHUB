// Role constants match the backend User.Role enum exactly.
export const ROLES = {
  ADMIN: 'ADMIN',
  SHOP_OWNER: 'SHOP_OWNER',
  CUSTOMER: 'CUSTOMER',
};

export const ROLE_LABELS = {
  ADMIN: 'Admin',
  SHOP_OWNER: 'Shop Owner',
  CUSTOMER: 'Customer',
};

// The landing route for each role after login / when hitting a wrong-role route.
export function roleHome(role) {
  switch (role) {
    case ROLES.ADMIN:
      return '/admin/dashboard';
    case ROLES.SHOP_OWNER:
      return '/shop-owner/dashboard';
    case ROLES.CUSTOMER:
      return '/customer/home';
    default:
      return '/login';
  }
}
