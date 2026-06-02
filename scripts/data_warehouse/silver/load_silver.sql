CREATE PROCEDURE silver.load_silver
AS
BEGIN
    SET NOCOUNT ON;

    /* =========================
       STEP 1: TRUNCATE SILVER
    ========================== */
    TRUNCATE TABLE silver.order_details;
    TRUNCATE TABLE silver.orders;
    TRUNCATE TABLE silver.pizza_types;
    TRUNCATE TABLE silver.pizzas;

    /* =========================
       STEP 2: LOAD ORDER DETAILS
    ========================== */
    INSERT INTO silver.order_details (
        order_details_id,
        order_id,
        pizza_id,
        quantity
    )
    SELECT 
        order_details_id,
        order_id,
        TRIM(pizza_id) AS pizza_id,
        quantity
    FROM bronze.order_details;

    /* =========================
       STEP 3: LOAD ORDERS
    ========================== */
    INSERT INTO silver.orders (
        order_id,
        order_date,
        order_time
    )
    SELECT 
        order_id,
        order_date,
        order_time
    FROM bronze.orders;

    /* =========================
       STEP 4: LOAD PIZZA TYPES
    ========================== */
    INSERT INTO silver.pizza_types (
        pizza_type_id,
        name,
        category,
        ingredients
    )
    SELECT 
        pizza_type_id,
        TRIM(name) AS name,
        TRIM(category) AS category,
        TRIM(ingredients) AS ingredients
    FROM bronze.pizza_types;

    /* =========================
       STEP 5: LOAD PIZZAS
    ========================== */
    INSERT INTO silver.pizzas (
        pizza_id,
        pizza_type,
        size,
        price
    )
    SELECT 
        TRIM(pizza_id) AS pizza_id,
        TRIM(pizza_type) AS pizza_type,
        CASE TRIM(size)
            WHEN 'L' THEN 'Large'
            WHEN 'M' THEN 'Medium'
            WHEN 'S' THEN 'Small'
            WHEN 'XL' THEN 'Extra Large'
            ELSE 'XXLarge'
        END AS size,
        price
    FROM bronze.pizzas;

END;