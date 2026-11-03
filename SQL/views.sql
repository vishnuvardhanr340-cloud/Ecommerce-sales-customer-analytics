--Monthly sales
CREATE VIEW vw_monthly_sales AS
SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(net_sales) AS revenue,
    SUM(profit) AS profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM raw_orders
GROUP BY DATE_TRUNC('month', order_date);

SELECT *
FROM vw_monthly_sales
ORDER BY month;


--product performanece
CREATE VIEW vw_product_performance AS
SELECT
    p.product_name,
    p.product_category,
    SUM(r.net_sales) AS total_revenue,
    SUM(r.profit) AS total_profit,
    ROUND(
        SUM(r.profit) / NULLIF(SUM(r.net_sales), 0) * 100,
        2
    ) AS profit_margin,
    SUM(r.quantity) AS units_sold
FROM raw_order_items r
JOIN raw_products p
    ON r.product_id = p.product_id
GROUP BY
    p.product_name,
    p.product_category;

SELECT *
FROM vw_product_performance
ORDER BY total_revenue DESC
LIMIT 10;


--Customer Summary 
CREATE VIEW vw_customer_summary AS
SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(net_sales) AS total_revenue,
    SUM(profit) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(net_sales), 0) * 100,
        2
    ) AS profit_margin,
    ROUND(
        SUM(net_sales) / NULLIF(COUNT(DISTINCT order_id), 0),
        2
    ) AS average_order_value
FROM raw_orders
GROUP BY
    customer_id,
    customer_name;

SELECT *
FROM vw_customer_summary
ORDER BY total_revenue DESC
LIMIT 10;


--msrketing performance 
CREATE VIEW vw_marketing_performance AS
SELECT
    marketing_channel,
    campaign_name,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(net_sales) AS total_revenue,
    SUM(profit) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(net_sales), 0) * 100,
        2
    ) AS profit_margin
FROM raw_orders
GROUP BY
    marketing_channel,
    campaign_name;

SELECT *
FROM vw_marketing_performance
ORDER BY total_revenue DESC
LIMIT 10;


-- Operations performance
CREATE VIEW vw_operations_performance AS
SELECT
    shipping_method,
    warehouse,
    delivery_status,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(AVG(delivery_days), 2) AS avg_delivery_days,
    ROUND(AVG(estimated_delivery_days), 2) AS avg_estimated_delivery_days,
    SUM(net_sales) AS total_revenue,
    SUM(profit) AS total_profit
FROM raw_orders
GROUP BY
    shipping_method,
    warehouse,
    delivery_status;

SELECT *
FROM vw_operations_performance
ORDER BY total_orders DESC
LIMIT 10;
