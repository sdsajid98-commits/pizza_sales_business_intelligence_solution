/*
===============================================================================
PIZZA SALES DATA WAREHOUSE - SILVER LAYER SETUP
===============================================================================
Purpose:
    ?

===============================================================================
*/


-- ============================================================================
-- SILVER TABLE: ORDER DETAILS
-- ============================================================================
DROP TABLE IF EXISTS silver.order_details;
GO

CREATE TABLE silver.order_details (
    order_details_id INT,
    order_id         INT,
    pizza_id         VARCHAR(100),
    quantity         INT
);
GO

-- ============================================================================
-- SILVER TABLE: ORDERS
-- ============================================================================
DROP TABLE IF EXISTS silver.orders;
GO

CREATE TABLE silver.orders (
    order_id INT,
    order_date DATE,
    order_time TIME
);
GO

-- ============================================================================
-- SILVER TABLE: PIZZA TYPES
-- ============================================================================
DROP TABLE IF EXISTS silver.pizza_types;
GO

CREATE TABLE silver.pizza_types (
    pizza_type_id VARCHAR(100),
    name          VARCHAR(100),
    category      VARCHAR(100),
    ingredients   VARCHAR(500)
);
GO

-- ============================================================================
-- silver TABLE: PIZZAS
-- ============================================================================
DROP TABLE IF EXISTS silver.pizzas;
GO

CREATE TABLE silver.pizzas (
    pizza_id   VARCHAR(100),
    pizza_type VARCHAR(100),
    size       VARCHAR(100),
    price      DECIMAL(10,2)
);
GO