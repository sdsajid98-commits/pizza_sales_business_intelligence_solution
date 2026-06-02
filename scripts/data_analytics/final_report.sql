/*
===============================================================================
VIEW: gold.report_pizza_performance
===============================================================================
Purpose:
    Evaluate individual pizza performance across sales and demand metrics.
===============================================================================
*/

CREATE OR ALTER VIEW gold.report_pizza_performance AS

WITH pizza_sales AS (

    SELECT
        p.pizza_type,
        p.name,
        p.category,
        p.size,
        p.price,

        SUM(f.quantity) AS total_quantity_sold,
        SUM(f.sales) AS total_sales,

        COUNT(DISTINCT f.order_id) AS total_orders,

        MAX(f.order_date) AS last_sale_date

    FROM gold.fact_sales AS f

    LEFT JOIN gold.dim_pizzas AS p
        ON f.pizza_id = p.pizza_id

    GROUP BY
        p.pizza_type,
        p.name,
        p.category,
        p.size,
        p.price
)

SELECT
    *,
    DATEDIFF(DAY,last_sale_date,'2016-01-01') AS days_since_last_sale,

    RANK() OVER(
        ORDER BY total_sales DESC
    ) AS sales_rank,

    CASE
        WHEN total_sales >= 10000 THEN 'High Performer'
        WHEN total_sales >= 5000 THEN 'Medium Performer'
        ELSE 'Low Performer'
    END AS performance_segment

FROM pizza_sales;
GO

/*
===============================================================================
VIEW: gold.report_category_performance
===============================================================================
Purpose:
    Evaluate menu category contribution and profitability.
===============================================================================
*/

CREATE OR ALTER VIEW gold.report_category_performance AS

WITH category_sales AS (

    SELECT
        p.category,

        SUM(f.sales) AS total_sales,
        SUM(f.quantity) AS total_quantity_sold,

        COUNT(DISTINCT f.order_id) AS total_orders

    FROM gold.fact_sales AS f

    LEFT JOIN gold.dim_pizzas AS p
        ON f.pizza_id = p.pizza_id

    GROUP BY p.category
)

SELECT
    *,

    ROUND(
        total_sales * 100.0 /
        SUM(total_sales) OVER (),
        2
    ) AS revenue_share_pct,

    RANK() OVER(
        ORDER BY total_sales DESC
    ) AS revenue_rank

FROM category_sales;
GO

/*
===============================================================================
VIEW: gold.report_sales_trend
===============================================================================
Purpose:
    Analyze daily sales trends and growth patterns.
===============================================================================
*/

CREATE OR ALTER VIEW gold.report_sales_trend AS

WITH daily_sales AS (

    SELECT
        order_date,

        SUM(sales) AS daily_sales,
        SUM(quantity) AS daily_quantity,

        COUNT(DISTINCT order_id) AS daily_orders

    FROM gold.fact_sales

    GROUP BY order_date
)

SELECT

    *,

    LAG(daily_sales) OVER(
        ORDER BY order_date
    ) AS previous_day_sales,

    daily_sales -
    LAG(daily_sales) OVER(
        ORDER BY order_date
    ) AS sales_change,

    SUM(daily_sales) OVER(
        ORDER BY order_date
    ) AS running_total_sales

FROM daily_sales;

GO

/*
===============================================================================
VIEW: gold.report_size_performance
===============================================================================
Purpose:
    Evaluate performance of pizza sizes.
===============================================================================
*/

CREATE OR ALTER VIEW gold.report_size_performance AS

WITH size_sales AS (

    SELECT
        p.size,

        SUM(f.sales) AS total_sales,
        SUM(f.quantity) AS total_quantity,

        COUNT(DISTINCT f.order_id) AS total_orders

    FROM gold.fact_sales AS f

    LEFT JOIN gold.dim_pizzas AS p
        ON f.pizza_id = p.pizza_id

    GROUP BY p.size
)

SELECT

    *,

    ROUND(
        total_sales * 100.0 /
        SUM(total_sales) OVER (),
        2
    ) AS revenue_share_pct,

    RANK() OVER(
        ORDER BY total_sales DESC
    ) AS size_rank

FROM size_sales;
GO

