-- KPI 
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    SUM(net_sales) AS total_revenue,
    SUM(profit) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(net_sales), 0) * 100, 2) AS profit_margin,
    ROUND(SUM(net_sales) / NULLIF(COUNT(DISTINCT order_id), 0), 2) AS average_order_value
FROM raw_orders;


-- revenue by month 
SELECT
    DATE_TRUNC('month', order_date) AS month,
    TO_CHAR(DATE_TRUNC('month',order_date),'Month') AS month_name,
    SUM(net_sales) AS revenue,
    SUM(profit) AS profit,
    COUNT(DISTINCT order_id) AS orders
FROM raw_orders
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;



-- sales by category 
SELECT
    p.product_category,
    SUM(oi.net_sales) AS revenue,
    SUM(oi.profit) AS profit,
    SUM(oi.quantity) AS units_sold
FROM raw_order_items oi
JOIN raw_products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category
ORDER BY revenue DESC;


-- sales and profit by product category
SELECT
    p.product_category,
    SUM(oi.net_sales) AS revenue,
    SUM(oi.profit) AS profit,
    SUM(oi.quantity) AS units_sold
FROM raw_order_items oi
JOIN raw_products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category
ORDER BY revenue DESC;


-- Category performance: Revenue vs Profit
SELECT
    p.product_category,
    SUM(oi.net_sales) AS revenue,
    SUM(oi.profit) AS profit,
    ROUND(
        SUM(oi.profit) / NULLIF(SUM(oi.net_sales), 0) * 100,
        2
    ) AS profit_margin,
    SUM(oi.quantity) AS units_sold
FROM raw_order_items oi
JOIN raw_products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category
ORDER BY revenue DESC;


-- Profit contribution by category
SELECT
    p.product_category,
    SUM(oi.profit) AS profit,
    ROUND(
        SUM(oi.profit) /
        NULLIF((SELECT SUM(profit) FROM raw_order_items), 0) * 100,
        2
    ) AS profit_contribution
FROM raw_order_items oi
JOIN raw_products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category
ORDER BY profit DESC;



-- Top 10 products by revenue
SELECT
    p.product_name,
    p.product_category,
    SUM(oi.net_sales) AS revenue,
    SUM(oi.profit) AS profit,
    SUM(oi.quantity) AS units_sold
FROM raw_order_items oi
JOIN raw_products p
    ON oi.product_id = p.product_id
GROUP BY
    p.product_name,
    p.product_category
ORDER BY revenue DESC
LIMIT 10;



-- Top 10 products: Revenue vs Profitability
SELECT
    p.product_name,
    p.product_category,
    SUM(oi.net_sales) AS revenue,
    SUM(oi.profit) AS profit,
    ROUND(
        SUM(oi.profit) / NULLIF(SUM(oi.net_sales), 0) * 100,
        2
    ) AS profit_margin,
    SUM(oi.quantity) AS units_sold
FROM raw_order_items oi
JOIN raw_products p
    ON oi.product_id = p.product_id
GROUP BY
    p.product_name,
    p.product_category
ORDER BY revenue DESC
LIMIT 10;


-- Top 10 products by profit margin
SELECT
    p.product_name,
    p.product_category,
    SUM(oi.net_sales) AS revenue,
    SUM(oi.profit) AS profit,
    ROUND(
        SUM(oi.profit) / NULLIF(SUM(oi.net_sales), 0) * 100,
        2
    ) AS profit_margin,
    SUM(oi.quantity) AS units_sold
FROM raw_order_items oi
JOIN raw_products p
    ON oi.product_id = p.product_id
GROUP BY
    p.product_name,
    p.product_category
ORDER BY profit_margin DESC
LIMIT 10;
