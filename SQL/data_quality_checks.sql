-- 1. Check row counts for all raw tables
SELECT 'customers' AS table_name, COUNT(*) AS row_count
FROM raw_customers

UNION ALL

SELECT 'products', COUNT(*)
FROM raw_products

UNION ALL

SELECT 'orders', COUNT(*)
FROM raw_orders

UNION ALL

SELECT 'order_items', COUNT(*)
FROM raw_order_items;


-- 2. Check for duplicate order IDs
SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM raw_orders
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;


-- 3. Check missing important order fields
SELECT
    COUNT(*) AS total_orders,
    COUNT(order_id) AS orders_with_id,
    COUNT(customer_id) AS orders_with_customer,
    COUNT(order_date) AS orders_with_date,
    COUNT(net_sales) AS orders_with_sales,
    COUNT(profit) AS orders_with_profit
FROM raw_orders;


-- 4. Check negative/invalid financial values
SELECT
    COUNT(*) FILTER (WHERE net_sales < 0) AS negative_sales,
    COUNT(*) FILTER (WHERE profit < 0) AS negative_profit,
    COUNT(*) FILTER (WHERE quantity <= 0) AS invalid_quantity
FROM raw_orders;


-- 5. Check invalid delivery values
SELECT
    COUNT(*) FILTER (WHERE delivery_days < 0) AS negative_delivery_days,
    COUNT(*) FILTER (WHERE estimated_delivery_days < 0) AS negative_estimated_days
FROM raw_orders;
