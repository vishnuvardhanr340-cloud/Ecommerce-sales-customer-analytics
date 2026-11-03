-- top 5 products by revenue  
SELECT 
    p.product_category,
    SUM(r.net_sales) AS total_revenue,
    SUM(r.profit) AS total_profit,
    ROUND(
        SUM(r.profit) / NULLIF(SUM(r.net_sales), 0) * 100,
        2
    ) AS profit_margin,
    SUM(r.quantity) AS total_units_sold
FROM raw_order_items r
JOIN raw_products p
    ON r.product_id = p.product_id
GROUP BY p.product_category
ORDER BY total_revenue DESC
LIMIT 5;


--top 5 products by profit maargin 
SELECT 
    p.product_category,
    SUM(r.net_sales) AS total_revenue,
    SUM(r.profit) AS total_profit,
    ROUND(
        SUM(r.profit) / NULLIF(SUM(r.net_sales), 0) * 100,
        2
    ) AS profit_margin,
    SUM(r.quantity) AS total_units_sold
FROM raw_order_items r
JOIN raw_products p
    ON r.product_id = p.product_id
GROUP BY p.product_category 
HAVING SUM(r.net_sales) >= 1000000 
ORDER BY profit_margin DESC
LIMIT 5;


--Category contribution to total revenue
SELECT 
    p.product_category,
    SUM(r.net_sales) AS total_revenue,
    ROUND(
        SUM(r.net_sales) /
        NULLIF(
            (SELECT SUM(net_sales) FROM raw_order_items),
            0
        ) * 100,
        2
    ) AS revenue_contribution_pct
FROM raw_order_items r
JOIN raw_products p
    ON r.product_id = p.product_id
GROUP BY p.product_category
ORDER BY revenue_contribution_pct DESC;



-- Product performance
SELECT 
    p.product_name,
    p.product_category,
    SUM(r.net_sales) AS total_revenue,
    SUM(r.profit) AS total_profit,
    ROUND(
        SUM(r.profit) / NULLIF(SUM(r.net_sales), 0) * 100,
        2
    ) AS profit_margin,
    SUM(r.quantity) AS total_units_sold
FROM raw_order_items r
JOIN raw_products p
    ON r.product_id = p.product_id
GROUP BY p.product_name,p.product_category 
HAVING SUM(r.net_sales) >= 500000
ORDER BY total_profit DESC
LIMIT 10;


-- customer revenue ranking 
SELECT 
    customer_id,
    customer_name,
    SUM(net_sales) AS total_revenue, 
    RANK() OVER(ORDER BY SUM(net_sales) DESC) AS revenue_rank
FROM raw_orders 
GROUP BY customer_id, customer_name;


--top 3 customers in each segment 
WITH customer_ranking AS (
    SELECT 
        customer_segment,
        customer_id,
        customer_name,
        SUM(net_sales) AS total_revenue,
        RANK() OVER (
            PARTITION BY customer_segment
            ORDER BY SUM(net_sales) DESC
        ) AS revenue_rank
    FROM raw_orders
    GROUP BY 
        customer_segment,
        customer_id,
        customer_name
)

SELECT
    customer_segment,
    customer_id,
    customer_name,
    total_revenue,
    revenue_rank
FROM customer_ranking
WHERE revenue_rank <= 3
ORDER BY customer_segment, revenue_rank;



--month over month revenue 
WITH revenue AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        SUM(net_sales) AS revenue
    FROM raw_orders
    GROUP BY DATE_TRUNC('month', order_date)
)

SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue,
    revenue - LAG(revenue) OVER (ORDER BY month) AS revenue_change
FROM revenue
ORDER BY month;



-- monthly revrnue growth percentage 
WITH revenue AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        SUM(net_sales) AS revenue
    FROM raw_orders
    GROUP BY DATE_TRUNC('month', order_date)
)

SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue,

    revenue - LAG(revenue) OVER (ORDER BY month) AS revenue_change,

    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY month))
        / NULLIF(LAG(revenue) OVER (ORDER BY month), 0) * 100,
        2
    ) AS revenue_change_pct

FROM revenue
ORDER BY month;


-- running total revenue 
WITH revenue AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        SUM(net_sales) AS revenue
    FROM raw_orders
    GROUP BY DATE_TRUNC('month', order_date)
)

SELECT
    month,
    revenue AS monthly_revenue,
    SUM(revenue) OVER (
        ORDER BY month
    ) AS running_total_revenue
FROM revenue
ORDER BY month;


-- YoY Revenue 
WITH yearly_revenue AS (
    SELECT 
        EXTRACT(YEAR FROM order_date) AS year,
        SUM(net_sales) AS revenue
    FROM raw_orders
    GROUP BY EXTRACT(YEAR FROM order_date)
)
SELECT
    year,
    revenue,
    LAG(revenue) OVER (ORDER BY year) AS previous_year_revenue,
    revenue - LAG(revenue) OVER (ORDER BY year) AS revenue_change,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY year))
        / NULLIF(LAG(revenue) OVER (ORDER BY year), 0) * 100,
        2
    ) AS revenue_change_pct
FROM yearly_revenue
ORDER BY year;


-- Ranking products within each category
WITH revenue AS (
    SELECT
        p.product_category,
        p.product_name,
        SUM(r.net_sales) AS total_revenue,
        RANK() OVER (
            PARTITION BY p.product_category
            ORDER BY SUM(r.net_sales) DESC
        ) AS revenue_rank
    FROM raw_order_items r
    JOIN raw_products p
        ON r.product_id = p.product_id
    GROUP BY
        p.product_category,
        p.product_name
)
SELECT
    product_category,
    product_name,
    total_revenue,
    revenue_rank
FROM revenue
WHERE revenue_rank <= 3
ORDER BY product_category, revenue_rank;


--customer ranking by segment 
WITH revenue_customer AS (
    SELECT
        c.customer_name,
        c.customer_id,
        c.customer_segment,
        SUM(o.net_sales) AS total_revenue,
        RANK() OVER (
            PARTITION BY c.customer_segment
            ORDER BY SUM(o.net_sales) DESC
        ) AS revenue_rank
    FROM raw_customers c
    JOIN raw_orders o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_name,
        c.customer_id,
        c.customer_segment
)
SELECT
    customer_name,
    customer_id,
    customer_segment,
    total_revenue,
    revenue_rank
FROM revenue_customer
WHERE revenue_rank <= 5
ORDER BY customer_segment, revenue_rank;


-- lowest customers revenue 
WITH revenue_customer AS (
    SELECT
        c.customer_name,
        c.customer_id,
        c.customer_segment,
        SUM(o.net_sales) AS total_revenue,
        RANK() OVER (
            PARTITION BY c.customer_segment
            ORDER BY SUM(o.net_sales) 
        ) AS revenue_rank
    FROM raw_customers c
    JOIN raw_orders o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_name,
        c.customer_id,
        c.customer_segment
)
SELECT
    customer_name,
    customer_id,
    customer_segment,
    total_revenue,
    revenue_rank
FROM revenue_customer
WHERE revenue_rank <= 5
ORDER BY customer_segment, revenue_rank;




--Revenue Rank vs Profit Rank
SELECT
    customer_id,
    customer_name,
    SUM(net_sales) AS total_revenue,
    SUM(profit) AS total_profit,

    RANK() OVER (
        ORDER BY SUM(net_sales) DESC
    ) AS revenue_rank,

    RANK() OVER (
        ORDER BY SUM(profit) DESC
    ) AS profit_rank

FROM raw_orders
GROUP BY
    customer_id,
    customer_name
ORDER BY revenue_rank, profit_rank;


--Customers with High Revenue but Low Profit 
SELECT
    customer_id,
    customer_name,
    SUM(net_sales) AS total_revenue,
    SUM(profit) AS total_profit,

    ROUND(
        SUM(profit) / NULLIF(SUM(net_sales), 0) * 100,
        2
    ) AS profit_margin,

    RANK() OVER (
        ORDER BY SUM(net_sales) DESC
    ) AS revenue_rank

FROM raw_orders

GROUP BY
    customer_id,
    customer_name

HAVING
    SUM(net_sales) > 20000
    AND SUM(profit) / NULLIF(SUM(net_sales), 0) * 100 < 30 

ORDER BY revenue_rank;


-- Revenue vs Profit Ranking Difference
WITH customer_ranks AS (
    SELECT
        customer_id,
        customer_name,
        SUM(net_sales) AS total_revenue,
        SUM(profit) AS total_profit,

        RANK() OVER (
            ORDER BY SUM(net_sales) DESC
        ) AS revenue_rank,

        RANK() OVER (
            ORDER BY SUM(profit) DESC
        ) AS profit_rank

    FROM raw_orders
    GROUP BY
        customer_id,
        customer_name
)

SELECT
    customer_id,
    customer_name,
    total_revenue,
    total_profit,
    revenue_rank,
    profit_rank,
    ABS(revenue_rank - profit_rank) AS rank_difference
FROM customer_ranks
WHERE ABS(revenue_rank - profit_rank) >= 10
ORDER BY rank_difference DESC;


--Customer Revenue vs Profit Ranking
WITH customer_ranks AS (
    SELECT
        customer_id,
        customer_name,
        SUM(net_sales) AS total_revenue,
        SUM(profit) AS total_profit,

        RANK() OVER (
            ORDER BY SUM(net_sales) DESC
        ) AS revenue_rank,

        RANK() OVER (
            ORDER BY SUM(profit) DESC
        ) AS profit_rank

    FROM raw_orders
    GROUP BY
        customer_id,
        customer_name
)

SELECT
    customer_id,
    customer_name,
    total_revenue,
    total_profit,
    revenue_rank,
    profit_rank,
    ABS(revenue_rank - profit_rank) AS rank_difference
FROM customer_ranks
WHERE revenue_rank <=20 and profit_rank>=50
ORDER BY revenue_rank;



--Customer Profitability vs Revenue
WITH customer_ranks AS (
    SELECT
        customer_id,
        customer_name,
        SUM(net_sales) AS total_revenue,
        SUM(profit) AS total_profit,

        ROUND(
            SUM(profit) / NULLIF(SUM(net_sales), 0) * 100,
            2
        ) AS profit_margin,

        RANK() OVER (
            ORDER BY SUM(net_sales) DESC
        ) AS revenue_rank,

        RANK() OVER (
            ORDER BY SUM(profit) DESC
        ) AS profit_rank

    FROM raw_orders
    GROUP BY
        customer_id,
        customer_name
)

SELECT
    customer_id,
    customer_name,
    total_revenue,
    total_profit,
    profit_margin,
    revenue_rank,
    profit_rank,
    ABS(revenue_rank - profit_rank) AS rank_difference
FROM customer_ranks
WHERE total_revenue > 30000
  AND profit_margin < 25
ORDER BY revenue_rank;


--Customer Profitability Classification
WITH customer_ranks AS (
    SELECT
        customer_id,
        customer_name,
        SUM(net_sales) AS total_revenue,
        SUM(profit) AS total_profit,

        ROUND(
            SUM(profit) / NULLIF(SUM(net_sales), 0) * 100,
            2
        ) AS profit_margin,

        RANK() OVER (
            ORDER BY SUM(net_sales) DESC
        ) AS revenue_rank,

        RANK() OVER (
            ORDER BY SUM(profit) DESC
        ) AS profit_rank,

        CASE
            WHEN SUM(net_sales) >= 50000
                 AND SUM(profit) / NULLIF(SUM(net_sales), 0) * 100 >= 25
                THEN 'VIP PROFITABLE'

            WHEN SUM(net_sales) >= 50000
                 AND SUM(profit) / NULLIF(SUM(net_sales), 0) * 100 < 25
                THEN 'VIP LOW MARGIN'

            WHEN SUM(net_sales) < 50000
                 AND SUM(profit) / NULLIF(SUM(net_sales), 0) * 100 >= 25
                THEN 'REGULAR PROFITABLE'

            ELSE 'REGULAR LOW MARGIN'
        END AS customer_type

    FROM raw_orders
    GROUP BY
        customer_id,
        customer_name
)

SELECT *
FROM customer_ranks;
