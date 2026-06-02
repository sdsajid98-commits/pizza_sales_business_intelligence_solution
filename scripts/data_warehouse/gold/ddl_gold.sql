/* =====================================
   FACT TABLE: SALES
===================================== */
CREATE VIEW gold.fact_sales AS
SELECT
    od.order_details_id,
    od.order_id,
    o.order_date,
    od.pizza_id,
    p.price,
    od.quantity,
    p.price * od.quantity AS sales
FROM silver.order_details AS od
LEFT JOIN silver.orders AS o
    ON od.order_id = o.order_id
LEFT JOIN silver.pizzas AS p
    ON od.pizza_id = p.pizza_id;


/* =====================================
   DIMENSION TABLE: PIZZAS
===================================== */
CREATE VIEW gold.dim_pizzas AS
SELECT
    p.pizza_id,
    p.pizza_type,
    pt.name,
    pt.category,
    pt.ingredients,
    p.size,
    p.price
FROM silver.pizzas AS p
LEFT JOIN silver.pizza_types AS pt
    ON p.pizza_type = pt.pizza_type_id;