/*
===============================================================================
PIZZA SALES DATA WAREHOUSE - BRONZE LAYER SETUP
===============================================================================
Purpose:
    This script creates the database, schemas, and raw ingestion tables
    for a Pizza Sales Data Warehouse using Medallion Architecture.

Layers:
    - Bronze: Raw source data (minimal transformation)
    - Silver: Cleaned and standardized data
    - Gold: Business-ready analytics models

Notes:
    - Bronze tables store data as-is from source files
    - NVARCHAR used where flexibility is required
    - Designed for re-runnable execution
===============================================================================
*/

-- ============================================================================
-- DATABASE CREATION (SAFE RE-RUN)
-- ============================================================================
IF DB_ID('pizza_sales') IS NULL
BEGIN
    CREATE DATABASE pizza_sales;
END
GO

USE pizza_sales;
GO

-- ============================================================================
-- SCHEMA CREATION (IDEMPOTENT)
-- ============================================================================
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'bronze')
    EXEC('CREATE SCHEMA bronze');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'silver')
    EXEC('CREATE SCHEMA silver');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'gold')
    EXEC('CREATE SCHEMA gold');
GO

-- ============================================================================
-- BRONZE TABLE: ORDER DETAILS
-- ============================================================================
DROP TABLE IF EXISTS bronze.order_details;
GO

CREATE TABLE bronze.order_details (
    order_details_id INT,
    order_id         INT,
    pizza_id         VARCHAR(100),
    quantity         INT
);
GO

-- ============================================================================
-- BRONZE TABLE: ORDERS
-- ============================================================================
DROP TABLE IF EXISTS bronze.orders;
GO

CREATE TABLE bronze.orders (
    order_id INT,
    order_date DATE,
    order_time TIME
);
GO

-- ============================================================================
-- BRONZE TABLE: PIZZA TYPES
-- ============================================================================
DROP TABLE IF EXISTS bronze.pizza_types;
GO

CREATE TABLE bronze.pizza_types (
    pizza_type_id VARCHAR(100),
    name          VARCHAR(100),
    category      VARCHAR(100),
    ingredients   VARCHAR(500)
);
GO

-- ============================================================================
-- BRONZE TABLE: PIZZAS
-- ============================================================================
DROP TABLE IF EXISTS bronze.pizzas;
GO

CREATE TABLE bronze.pizzas (
    pizza_id   VARCHAR(100),
    pizza_type VARCHAR(100),
    size       VARCHAR(100),
    price      DECIMAL(10,2)
);
GO