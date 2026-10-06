-- E-commerce Sales Analysis
-- PostgreSQL
-- Dataset: ecommerce_sales
-- 1,000 orders | January-August 2026

-- ============================================================
-- 1. DATA VALIDATION
-- ============================================================

SELECT COUNT(*) AS total_rows
FROM ecommerce_sales;

SELECT COUNT(DISTINCT order_id) AS unique_orders
FROM ecommerce_sales;

SELECT
    COUNT(*) AS total_rows,
    COUNT(order_id) AS order_id_present,
    COUNT(order_date) AS order_date_present,
    COUNT(customer) AS customer_present,
    COUNT(product) AS product_present,
    COUNT(category) AS category_present,
    COUNT(region) AS region_present,
    COUNT(quantity) AS quantity_present,
    COUNT(unit_price) AS unit_price_present,
    COUNT(discount) AS discount_present,
    COUNT(sales) AS sales_present,
    COUNT(payment_method) AS payment_method_present
FROM ecommerce_sales;

SELECT
    MIN(order_date) AS earliest_date,
    MAX(order_date) AS latest_date
FROM ecommerce_sales;

SELECT
    MIN(quantity) AS min_quantity,
    MAX(quantity) AS max_quantity,
    MIN(unit_price) AS min_unit_price,
    MAX(unit_price) AS max_unit_price,
    MIN(discount) AS min_discount,
    MAX(discount) AS max_discount,
    MIN(sales) AS min_sales,
    MAX(sales) AS max_sales
FROM ecommerce_sales;


-- ============================================================
-- 2. CORE BUSINESS METRICS
-- ============================================================

SELECT
    SUM(sales) AS total_revenue
FROM ecommerce_sales;

SELECT
    COUNT(DISTINCT order_id) AS total_orders
FROM ecommerce_sales;

SELECT
    SUM(quantity) AS total_units_sold
FROM ecommerce_sales;

SELECT
    ROUND(
        SUM(sales)::numeric / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM ecommerce_sales;

SELECT
    ROUND(
        SUM(quantity)::numeric / COUNT(DISTINCT order_id),
        2
    ) AS average_quantity_per_order
FROM ecommerce_sales;

SELECT
    SUM(discount) AS total_discount_percentage_points
FROM ecommerce_sales;

SELECT
    ROUND(
        SUM(discount)::numeric / COUNT(DISTINCT order_id),
        2
    ) AS average_discount_percentage
FROM ecommerce_sales;


-- ============================================================
-- 3. CATEGORY ANALYSIS
-- ============================================================

SELECT
    category,
    SUM(sales) AS total_revenue
FROM ecommerce_sales
GROUP BY category
ORDER BY total_revenue DESC;

SELECT
    product,
    SUM(sales) AS revenue_by_product
FROM ecommerce_sales
GROUP BY product
ORDER BY revenue_by_product DESC;

SELECT
    category,
    COUNT(DISTINCT order_id) AS total_orders
FROM ecommerce_sales
GROUP BY category
ORDER BY total_orders DESC;

SELECT
    category,
    ROUND(
        SUM(sales)::numeric / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM ecommerce_sales
GROUP BY category
ORDER BY average_order_value DESC;


-- ============================================================
-- 4. REGIONAL ANALYSIS
-- ============================================================

SELECT
    region,
    SUM(sales) AS total_revenue
FROM ecommerce_sales
GROUP BY region
ORDER BY total_revenue DESC;

SELECT
    region,
    COUNT(DISTINCT order_id) AS total_orders
FROM ecommerce_sales
GROUP BY region
ORDER BY total_orders DESC;

SELECT
    region,
    ROUND(
        SUM(sales)::numeric / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM ecommerce_sales
GROUP BY region
ORDER BY average_order_value DESC;


-- ============================================================
-- 5. PAYMENT METHOD ANALYSIS
-- ============================================================

SELECT
    payment_method,
    SUM(sales) AS total_revenue
FROM ecommerce_sales
GROUP BY payment_method
ORDER BY total_revenue DESC;

SELECT
    payment_method,
    COUNT(DISTINCT order_id) AS total_orders
FROM ecommerce_sales
GROUP BY payment_method
ORDER BY total_orders DESC;

SELECT
    payment_method,
    ROUND(
        SUM(sales)::numeric / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM ecommerce_sales
GROUP BY payment_method
ORDER BY average_order_value DESC;


-- ============================================================
-- 6. HAVING / FILTERED GROUP ANALYSIS
-- ============================================================

-- Categories generating more than 500,000 in revenue
SELECT
    category,
    SUM(sales) AS total_revenue
FROM ecommerce_sales
GROUP BY category
HAVING SUM(sales) > 500000
ORDER BY total_revenue DESC;

-- Regions with more than 100 orders
SELECT
    region,
    COUNT(DISTINCT order_id) AS total_orders
FROM ecommerce_sales
GROUP BY region
HAVING COUNT(DISTINCT order_id) > 100
ORDER BY total_orders DESC;


-- ============================================================
-- 7. CASE / BUSINESS LOGIC
-- ============================================================

-- Classify individual orders by sales value
SELECT
    order_id,
    sales,
    CASE
        WHEN sales > 50000 THEN 'High'
        WHEN sales > 10000 THEN 'Medium'
        ELSE 'Low'
    END AS sales_category
FROM ecommerce_sales;

-- Count orders by sales category
SELECT
    CASE
        WHEN sales > 50000 THEN 'High'
        WHEN sales > 10000 THEN 'Medium'
        ELSE 'Low'
    END AS sales_category,
    COUNT(*) AS total_orders
FROM ecommerce_sales
GROUP BY sales_category
ORDER BY total_orders DESC;

-- Classify rows by unit price
SELECT
    product,
    unit_price,
    CASE
        WHEN unit_price > 20000 THEN 'Premium'
        WHEN unit_price > 5000 THEN 'Mid-range'
        ELSE 'Budget'
    END AS price_category
FROM ecommerce_sales;

-- Count rows by price category
SELECT
    CASE
        WHEN unit_price > 20000 THEN 'Premium'
        WHEN unit_price > 5000 THEN 'Mid-range'
        ELSE 'Budget'
    END AS price_category,
    COUNT(*) AS total_rows
FROM ecommerce_sales
GROUP BY price_category
ORDER BY total_rows DESC;

-- Revenue by price category
SELECT
    CASE
        WHEN unit_price > 20000 THEN 'Premium'
        WHEN unit_price > 5000 THEN 'Mid-range'
        ELSE 'Budget'
    END AS price_category,
    SUM(sales) AS total_revenue
FROM ecommerce_sales
GROUP BY price_category
ORDER BY total_revenue DESC;


-- ============================================================
-- 8. CONDITIONAL AGGREGATION
-- ============================================================

-- Premium revenue
SELECT
    SUM(
        CASE
            WHEN unit_price > 20000 THEN sales
            ELSE 0
        END
    ) AS premium_revenue
FROM ecommerce_sales;

-- Premium vs non-premium revenue
SELECT
    SUM(
        CASE
            WHEN unit_price > 20000 THEN sales
            ELSE 0
        END
    ) AS premium_revenue,
    SUM(
        CASE
            WHEN unit_price <= 20000 THEN sales
            ELSE 0
        END
    ) AS non_premium_revenue
FROM ecommerce_sales;

-- Premium vs non-premium orders
-- order_id is unique in this dataset, so COUNT(*) is sufficient.
SELECT
    COUNT(
        CASE
            WHEN unit_price > 20000 THEN order_id
        END
    ) AS premium_orders,
    COUNT(
        CASE
            WHEN unit_price <= 20000 THEN order_id
        END
    ) AS non_premium_orders
FROM ecommerce_sales;


-- ============================================================
-- 9. DISCOUNT ANALYSIS
-- ============================================================

-- Classify orders by discount
SELECT
    order_id,
    discount,
    CASE
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 10 THEN 'Low Discount'
        ELSE 'High Discount'
    END AS discount_category
FROM ecommerce_sales;

-- Orders by discount category
SELECT
    CASE
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 10 THEN 'Low Discount'
        ELSE 'High Discount'
    END AS discount_category,
    COUNT(*) AS total_orders
FROM ecommerce_sales
GROUP BY discount_category
ORDER BY total_orders DESC;

-- Revenue by discount category
SELECT
    CASE
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 10 THEN 'Low Discount'
        ELSE 'High Discount'
    END AS discount_category,
    SUM(sales) AS total_revenue
FROM ecommerce_sales
GROUP BY discount_category
ORDER BY total_revenue DESC;

-- Average order sales by discount category
SELECT
    CASE
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 10 THEN 'Low Discount'
        ELSE 'High Discount'
    END AS discount_category,
    ROUND(AVG(sales)::numeric, 2) AS average_order_sales
FROM ecommerce_sales
GROUP BY discount_category
ORDER BY average_order_sales DESC;


-- ============================================================
-- 10. DATE / MONTHLY ANALYSIS
-- ============================================================

-- Revenue by month
SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(sales) AS monthly_revenue
FROM ecommerce_sales
GROUP BY month
ORDER BY month;

-- Orders by month
SELECT
    DATE_TRUNC('month', order_date) AS month,
    COUNT(*) AS total_orders
FROM ecommerce_sales
GROUP BY month
ORDER BY month;

-- Units sold by month
SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(quantity) AS total_units
FROM ecommerce_sales
GROUP BY month
ORDER BY month;

-- Monthly AOV
SELECT
    DATE_TRUNC('month', order_date) AS month,
    ROUND(
        SUM(sales)::numeric / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM ecommerce_sales
GROUP BY month
ORDER BY month;


-- ============================================================
-- 11. TOP PRODUCTS
-- ============================================================

SELECT
    product,
    SUM(sales) AS total_revenue
FROM ecommerce_sales
GROUP BY product
ORDER BY total_revenue DESC
LIMIT 5;

SELECT
    product,
    SUM(quantity) AS total_units
FROM ecommerce_sales
GROUP BY product
ORDER BY total_units DESC
LIMIT 5;


-- ============================================================
-- 12. SUBQUERY ANALYSIS
-- ============================================================

-- Products generating more revenue than the average product
SELECT
    product,
    SUM(sales) AS total_revenue
FROM ecommerce_sales
GROUP BY product
HAVING SUM(sales) > (
    SELECT AVG(product_revenue)
    FROM (
        SELECT
            product,
            SUM(sales) AS product_revenue
        FROM ecommerce_sales
        GROUP BY product
    ) AS product_totals
)
ORDER BY total_revenue DESC;


-- ============================================================
-- 13. CTE ANALYSIS
-- ============================================================

-- Products above average revenue
WITH product_totals AS (
    SELECT
        product,
        SUM(sales) AS total_revenue
    FROM ecommerce_sales
    GROUP BY product
)
SELECT
    product,
    total_revenue
FROM product_totals
WHERE total_revenue > (
    SELECT AVG(total_revenue)
    FROM product_totals
)
ORDER BY total_revenue DESC;


-- ============================================================
-- 14. WINDOW FUNCTIONS
-- ============================================================

-- Rank products by revenue
SELECT
    product,
    SUM(sales) AS total_revenue,
    RANK() OVER (
        ORDER BY SUM(sales) DESC
    ) AS revenue_rank
FROM ecommerce_sales
GROUP BY product
ORDER BY revenue_rank;


-- Product share of total revenue
WITH product_totals AS (
    SELECT
        product,
        SUM(sales) AS total_revenue
    FROM ecommerce_sales
    GROUP BY product
)
SELECT
    product,
    total_revenue,
    ROUND(
        100 * total_revenue
        / SUM(total_revenue) OVER (),
        2
    ) AS revenue_percentage
FROM product_totals
ORDER BY total_revenue DESC;


-- Cumulative monthly revenue
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        SUM(sales) AS monthly_revenue
    FROM ecommerce_sales
    GROUP BY month
)
SELECT
    month,
    monthly_revenue,
    SUM(monthly_revenue) OVER (
        ORDER BY month
    ) AS cumulative_revenue
FROM monthly_sales
ORDER BY month;


-- Month-over-month revenue growth
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        SUM(sales) AS monthly_revenue
    FROM ecommerce_sales
    GROUP BY month
),
previous_month AS (
    SELECT
        month,
        monthly_revenue,
        LAG(monthly_revenue) OVER (
            ORDER BY month
        ) AS previous_month_revenue
    FROM monthly_sales
)
SELECT
    month,
    monthly_revenue,
    previous_month_revenue,
    ROUND(
        100 * (
            monthly_revenue - previous_month_revenue
        ) / NULLIF(previous_month_revenue, 0),
        2
    ) AS month_over_month_growth
FROM previous_month
ORDER BY month;


-- ============================================================
-- 15. REVENUE CONTRIBUTION
-- ============================================================

-- Category share of total revenue
WITH category_sales AS (
    SELECT
        category,
        SUM(sales) AS category_revenue
    FROM ecommerce_sales
    GROUP BY category
)
SELECT
    category,
    category_revenue,
    ROUND(
        100 * category_revenue
        / SUM(category_revenue) OVER (),
        2
    ) AS revenue_percentage
FROM category_sales
ORDER BY category_revenue DESC;


-- ============================================================
-- 16. TOP PRODUCT WITHIN EACH CATEGORY
-- ============================================================

WITH product_sales AS (
    SELECT
        category,
        product,
        SUM(sales) AS product_revenue
    FROM ecommerce_sales
    GROUP BY category, product
),
ranked_products AS (
    SELECT
        category,
        product,
        product_revenue,
        RANK() OVER (
            PARTITION BY category
            ORDER BY product_revenue DESC
        ) AS category_rank
    FROM product_sales
)
SELECT
    category,
    product,
    product_revenue
FROM ranked_products
WHERE category_rank = 1
ORDER BY product_revenue DESC;
