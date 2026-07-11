create database supply_chain_db;
use supply_chain_db;
SELECT 
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    
    -- way to calculate actual delivery time (Returns difference in days)
    DATEDIFF(order_delivered_customer_date, order_purchase_timestamp) AS actual_delivery_days,
    
    -- way to calculate promised delivery time
    DATEDIFF(order_estimated_delivery_date, order_purchase_timestamp) AS estimated_delivery_days,
    
    -- Flagging delayed orders
    CASE 
        WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 'Delayed'
        ELSE 'On-Time/Early'
    END AS delivery_status
FROM olist_orders_dataset -- Calling my imported table here
WHERE order_status = 'delivered' 
  AND order_delivered_customer_date IS NOT NULL
LIMIT 100; -- Keeps it fast by loading just the first 100 rows
SELECT 
    c.customer_state,
    COUNT(o.order_id) AS total_orders,
    
    -- Average days taken to deliver (MySQL friendly)
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 2) AS avg_delivery_days,
    
    -- Average days over or under the estimated date
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date)), 2) AS avg_days_over_estimate

FROM olist_orders_dataset o
JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered' 
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_days_over_estimate DESC;
WITH ProductRevenue AS (
    -- Step 1: Calculate total revenue per product category
    SELECT 
        p.product_category_name,
        SUM(i.price) AS total_revenue,
        COUNT(i.order_id) AS units_sold
    FROM olist_order_items_dataset i
    JOIN olist_products_dataset p ON i.product_id = p.product_id
    GROUP BY p.product_category_name
),
CumulativeRevenue AS (
    -- Step 2: Calculate running total and percentage of total revenue
    SELECT 
        product_category_name,
        total_revenue,
        units_sold,
        SUM(total_revenue) OVER(ORDER BY total_revenue DESC) AS running_total,
        SUM(total_revenue) OVER() AS global_total
    FROM ProductRevenue
)
-- Step 3: Classify into A, B, and C segments
SELECT 
    product_category_name,
    total_revenue,
    units_sold,
    ROUND((running_total / global_total) * 100, 2) AS cumulative_percentage,
    CASE 
        WHEN (running_total / global_total) <= 0.80 THEN 'A (High Value / High Priority)'
        WHEN (running_total / global_total) <= 0.95 THEN 'B (Moderate Value)'
        ELSE 'C (Low Value / Bulk Stock)'
    END AS abc_class
FROM CumulativeRevenue
ORDER BY total_revenue DESC;