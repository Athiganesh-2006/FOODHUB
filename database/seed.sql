-- ============================================================
-- Food Hub — Seed Data
-- Run AFTER schema.sql
-- ============================================================

-- Default Admin User
-- Credentials: admin@foodhub.com / admin123
-- Password is BCrypt-hashed (bcrypt of "admin123")
INSERT INTO users (name, email, password, phone, address, role)
VALUES (
    'Admin',
    'admin@foodhub.com',
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
    '9999999999',
    'Food Hub HQ',
    'ADMIN'
) ON CONFLICT (email) DO NOTHING;

-- ============================================================
-- Sample Shop Owner (for testing)
-- Credentials: owner@foodhub.com / owner123
-- ============================================================
INSERT INTO users (name, email, password, phone, address, role)
VALUES (
    'Shop Owner 1',
    'owner@foodhub.com',
    '$2a$10$8K1p/a0dL1LXMIgoEDFrwOfMQkLzMUkrNEFdNcvJKF5.HxXJCbkTi',
    '8888888888',
    '123 Main Street',
    'SHOP_OWNER'
) ON CONFLICT (email) DO NOTHING;

-- ============================================================
-- Sample Customer (for testing)
-- Credentials: customer@foodhub.com / customer123
-- ============================================================
INSERT INTO users (name, email, password, phone, address, role)
VALUES (
    'Test Customer',
    'customer@foodhub.com',
    '$2a$10$uyhtlWxzMNSWN7Gez3KWyO3mVJWnAjGTbXyDFoBpHYzWwP6fXjWt.',
    '7777777777',
    '456 Oak Avenue',
    'CUSTOMER'
) ON CONFLICT (email) DO NOTHING;

-- ============================================================
-- Sample Shop linked to Shop Owner
-- ============================================================
INSERT INTO shops (name, description, address, phone, shop_owner_id, availability)
SELECT 
    'ABC Canteen',
    'A cozy canteen serving South Indian delicacies and fast food.',
    'Block A, Ground Floor, Campus',
    '9876543210',
    u.id,
    'OPEN'
FROM users u WHERE u.email = 'owner@foodhub.com'
ON CONFLICT DO NOTHING;

-- ============================================================
-- Sample Foods
-- ============================================================
INSERT INTO foods (shop_id, name, description, price, category, availability)
SELECT s.id, 'Masala Dosa', 'Crispy dosa with spicy potato filling', 80.00, 'BREAKFAST', true
FROM shops s WHERE s.name = 'ABC Canteen'
ON CONFLICT DO NOTHING;

INSERT INTO foods (shop_id, name, description, price, category, availability)
SELECT s.id, 'Veg Burger', 'Juicy vegetable burger with lettuce and cheese', 120.00, 'FAST_FOOD', true
FROM shops s WHERE s.name = 'ABC Canteen'
ON CONFLICT DO NOTHING;

INSERT INTO foods (shop_id, name, description, price, category, availability)
SELECT s.id, 'Chicken Biryani', 'Aromatic basmati rice with tender chicken', 200.00, 'LUNCH', true
FROM shops s WHERE s.name = 'ABC Canteen'
ON CONFLICT DO NOTHING;

INSERT INTO foods (shop_id, name, description, price, category, availability)
SELECT s.id, 'Cold Coffee', 'Chilled coffee with milk and chocolate syrup', 60.00, 'BEVERAGES', true
FROM shops s WHERE s.name = 'ABC Canteen'
ON CONFLICT DO NOTHING;
