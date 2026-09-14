-- ============================================================
-- Food Hub — Supabase PostgreSQL Schema
-- Run this in Supabase SQL Editor (Dashboard → SQL Editor)
-- ============================================================

-- 1. USERS
CREATE TABLE IF NOT EXISTS users (
    id          BIGSERIAL PRIMARY KEY,
    name        VARCHAR(255)        NOT NULL,
    email       VARCHAR(255)        NOT NULL UNIQUE,
    password    VARCHAR(255)        NOT NULL,
    phone       VARCHAR(50),
    address     TEXT,
    role        VARCHAR(20)         NOT NULL CHECK (role IN ('ADMIN', 'SHOP_OWNER', 'CUSTOMER')),
    created_at  TIMESTAMP           DEFAULT NOW(),
    updated_at  TIMESTAMP           DEFAULT NOW()
);

-- 2. SHOPS
CREATE TABLE IF NOT EXISTS shops (
    id              BIGSERIAL PRIMARY KEY,
    name            VARCHAR(255)    NOT NULL,
    description     TEXT,
    address         TEXT,
    phone           VARCHAR(50),
    shop_owner_id   BIGINT          NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    availability    VARCHAR(10)     NOT NULL DEFAULT 'OPEN' CHECK (availability IN ('OPEN', 'CLOSED')),
    created_at      TIMESTAMP       DEFAULT NOW(),
    updated_at      TIMESTAMP       DEFAULT NOW()
);

-- 3. FOODS
CREATE TABLE IF NOT EXISTS foods (
    id              BIGSERIAL PRIMARY KEY,
    shop_id         BIGINT          NOT NULL REFERENCES shops(id) ON DELETE CASCADE,
    name            VARCHAR(255)    NOT NULL,
    description     TEXT,
    price           NUMERIC(10, 2)  NOT NULL,
    category        VARCHAR(20)     CHECK (category IN ('BREAKFAST','LUNCH','DINNER','SNACKS','BEVERAGES','FAST_FOOD','DESSERTS')),
    image_url       TEXT,
    availability    BOOLEAN         NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMP       DEFAULT NOW(),
    updated_at      TIMESTAMP       DEFAULT NOW()
);

-- 4. CARTS
CREATE TABLE IF NOT EXISTS carts (
    id              BIGSERIAL PRIMARY KEY,
    customer_id     BIGINT          NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    created_at      TIMESTAMP       DEFAULT NOW(),
    updated_at      TIMESTAMP       DEFAULT NOW()
);

-- 5. CART_ITEMS
CREATE TABLE IF NOT EXISTS cart_items (
    id          BIGSERIAL PRIMARY KEY,
    cart_id     BIGINT          NOT NULL REFERENCES carts(id) ON DELETE CASCADE,
    food_id     BIGINT          NOT NULL REFERENCES foods(id) ON DELETE CASCADE,
    quantity    INTEGER         NOT NULL CHECK (quantity > 0),
    price       NUMERIC(10, 2)  NOT NULL,
    created_at  TIMESTAMP       DEFAULT NOW(),
    updated_at  TIMESTAMP       DEFAULT NOW()
);

-- 6. ORDERS
CREATE TABLE IF NOT EXISTS orders (
    id              BIGSERIAL PRIMARY KEY,
    customer_id     BIGINT          NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    total_amount    NUMERIC(10, 2)  NOT NULL,
    payment_status  VARCHAR(10)     NOT NULL DEFAULT 'PENDING' CHECK (payment_status IN ('PENDING','SUCCESS','FAILED')),
    order_status    VARCHAR(10)     NOT NULL DEFAULT 'PENDING' CHECK (order_status IN ('PENDING','ACCEPTED','REJECTED','COMPLETED')),
    created_at      TIMESTAMP       DEFAULT NOW(),
    updated_at      TIMESTAMP       DEFAULT NOW()
);

-- 7. ORDER_ITEMS
CREATE TABLE IF NOT EXISTS order_items (
    id          BIGSERIAL PRIMARY KEY,
    order_id    BIGINT          NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    food_id     BIGINT          REFERENCES foods(id) ON DELETE SET NULL,
    shop_id     BIGINT          REFERENCES shops(id) ON DELETE SET NULL,
    food_name   VARCHAR(255)    NOT NULL,
    quantity    INTEGER         NOT NULL CHECK (quantity > 0),
    price       NUMERIC(10, 2)  NOT NULL,
    item_status VARCHAR(10)     NOT NULL DEFAULT 'PENDING' CHECK (item_status IN ('PENDING','ACCEPTED','REJECTED','COMPLETED')),
    created_at  TIMESTAMP       DEFAULT NOW()
);

-- ============================================================
-- Indexes for performance
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_users_email     ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role      ON users(role);
CREATE INDEX IF NOT EXISTS idx_shops_owner     ON shops(shop_owner_id);
CREATE INDEX IF NOT EXISTS idx_foods_shop      ON foods(shop_id);
CREATE INDEX IF NOT EXISTS idx_foods_category  ON foods(category);
CREATE INDEX IF NOT EXISTS idx_carts_customer  ON carts(customer_id);
CREATE INDEX IF NOT EXISTS idx_cart_items_cart ON cart_items(cart_id);
CREATE INDEX IF NOT EXISTS idx_orders_customer ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_order_items_ord ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_shp ON order_items(shop_id);
