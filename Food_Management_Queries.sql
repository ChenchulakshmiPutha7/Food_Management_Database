-- 1. Show all customers (first 10)

SELECT * 
FROM customers 
LIMIT 10;

-- 2. Show all restaurants and ratings (top 20)
SELECT restaurant_id, restaurant_name, category, city, rating
FROM restaurants
ORDER BY rating DESC
LIMIT 20;

-- 3. List menu items for a restaurant (example: restaurant_id = 1)
SELECT mi.*
FROM menu_items mi
WHERE mi.restaurant_id = 1;

-- 4. Simple order lookup (last 20)

SELECT o.order_id, o.order_time, o.total_amount, o.status
FROM orders o
ORDER BY o.order_time DESC
LIMIT 20;

-- 5. Payment status counts

SELECT payment_status, COUNT(*) AS cnt
FROM payments
GROUP BY payment_status;

-- 6. Orders with customer & restaurant names (last 20)

SELECT o.order_id, c.full_name AS customer, r.restaurant_name AS restaurant,
       o.total_amount, o.status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
ORDER BY o.order_time DESC
LIMIT 20;

-- 7. Order items with menu names (example: order_id = 1)

SELECT oi.order_item_id, oi.order_id, mi.item_name, oi.quantity, oi.price
FROM order_items oi
JOIN menu_items mi ON oi.item_id = mi.item_id
WHERE oi.order_id = 1;

-- 8. Total orders per restaurant

SELECT r.restaurant_id, r.restaurant_name, COUNT(o.order_id) AS total_orders
FROM restaurants r
LEFT JOIN orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_id
ORDER BY total_orders DESC;

-- 9. Total revenue per restaurant (successful payments)

SELECT r.restaurant_name, SUM(p.amount) AS revenue
FROM restaurants r
JOIN orders o ON r.restaurant_id = o.restaurant_id
JOIN payments p ON o.order_id = p.order_id
WHERE p.payment_status = 'Success'
GROUP BY r.restaurant_id
ORDER BY revenue DESC;

-- 10. Customer spending (top 10)

SELECT c.customer_id, c.full_name, SUM(p.amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
WHERE p.payment_status = 'Success'
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 10;

-- 11. Most popular menu items (by quantity, top 10)

SELECT mi.item_id, mi.item_name, SUM(oi.quantity) AS qty_sold
FROM menu_items mi
JOIN order_items oi ON mi.item_id = oi.item_id
GROUP BY mi.item_id
ORDER BY qty_sold DESC
LIMIT 10;

-- 12. Delivery partner performance (delivered count)

SELECT dp.partner_id, dp.full_name, COUNT(d.delivery_id) AS delivered_count
FROM delivery_partners dp
LEFT JOIN deliveries d 
       ON dp.partner_id = d.partner_id AND d.delivery_status = 'Delivered'
GROUP BY dp.partner_id
ORDER BY delivered_count DESC;

-- 13. Average rating per restaurant

SELECT r.restaurant_id, r.restaurant_name,
       COALESCE(AVG(rv.rating), 0) AS avg_rating
FROM restaurants r
LEFT JOIN reviews rv ON r.restaurant_id = rv.restaurant_id
GROUP BY r.restaurant_id
ORDER BY avg_rating DESC;

-- 14. Customers with no orders

SELECT c.customer_id, c.full_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- 15. Failed payments list

SELECT p.payment_id, p.order_id, p.amount, p.payment_method, p.payment_status
FROM payments p
WHERE p.payment_status <> 'Success';

-- 16. Top 5 customers by completed payments

SELECT c.customer_id, c.full_name, SUM(p.amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id AND p.payment_status = 'Success'
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 5;

-- 17. Restaurants with order & revenue summary

SELECT r.restaurant_id, r.restaurant_name,
       COUNT(DISTINCT o.order_id) AS orders_count,
       SUM(CASE WHEN p.payment_status='Success' THEN p.amount ELSE 0 END) AS revenue
FROM restaurants r
LEFT JOIN orders o ON r.restaurant_id = o.restaurant_id
LEFT JOIN payments p ON o.order_id = p.order_id
GROUP BY r.restaurant_id
ORDER BY revenue DESC;

-- 18. Top selling items with restaurant name (top 10)

SELECT mi.item_id, mi.item_name, r.restaurant_name, SUM(oi.quantity) AS sold_qty
FROM order_items oi
JOIN menu_items mi ON oi.item_id = mi.item_id
JOIN restaurants r ON mi.restaurant_id = r.restaurant_id
GROUP BY mi.item_id
ORDER BY sold_qty DESC
LIMIT 10;

-- 19. Average delivery time (if delivery_time available)

SELECT SEC_TO_TIME(AVG(TIMESTAMPDIFF(SECOND, o.order_time, d.delivery_time))) AS avg_delivery_duration
FROM orders o
JOIN deliveries d ON o.order_id = d.order_id
WHERE d.delivery_status = 'Delivered' AND d.delivery_time IS NOT NULL;

-- 20. Customers with last order > 30 days

SELECT c.customer_id, c.full_name, MAX(o.order_time) AS last_order
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING last_order < NOW() - INTERVAL 30 DAY OR last_order IS NULL;

-- 21. Monthly revenue (last 6 months)

SELECT DATE_FORMAT(p.payment_time, '%Y-%m') AS month, SUM(p.amount) AS revenue
FROM payments p
WHERE p.payment_status = 'Success' AND p.payment_time >= NOW() - INTERVAL 6 MONTH
GROUP BY month
ORDER BY month DESC;

-- 22. Runner-up restaurants for a city (top 3 by revenue)

SELECT r.city, r.restaurant_name, SUM(p.amount) AS revenue
FROM restaurants r
JOIN orders o ON r.restaurant_id = o.restaurant_id
JOIN payments p ON o.order_id = p.order_id AND p.payment_status='Success'
WHERE r.city = 'Bangalore'
GROUP BY r.restaurant_id
ORDER BY revenue DESC
LIMIT 3;

-- 23. Average basket value per customer (top 10)

SELECT c.customer_id, c.full_name, AVG(o.total_amount) AS avg_basket
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY avg_basket DESC
LIMIT 10;

-- 24. Items often ordered together (top 10 pairs)

SELECT oi1.item_id AS item_a, oi2.item_id AS item_b, COUNT(*) AS pair_count
FROM order_items oi1
JOIN order_items oi2 ON oi1.order_id = oi2.order_id AND oi1.item_id < oi2.item_id
GROUP BY oi1.item_id, oi2.item_id
ORDER BY pair_count DESC
LIMIT 10;

-- 25. Restaurants with most 5-star reviews (top 10)

SELECT r.restaurant_id, r.restaurant_name,
       SUM(CASE WHEN rv.rating=5 THEN 1 ELSE 0 END) AS five_star_count
FROM restaurants r
LEFT JOIN reviews rv ON r.restaurant_id = rv.restaurant_id
GROUP BY r.restaurant_id
ORDER BY five_star_count DESC
LIMIT 10;

-- 26. Recalculate and update restaurant ratings (optimized)

UPDATE restaurants r
JOIN (
    SELECT restaurant_id, ROUND(AVG(rating),2) AS avg_rating
    FROM reviews
    GROUP BY restaurant_id
) rv ON r.restaurant_id = rv.restaurant_id
SET r.rating = rv.avg_rating;

-- 27. Cancelled orders older than 30 days

DELETE FROM orders
WHERE status='Cancelled' AND order_time < NOW() - INTERVAL 30 DAY;

-- 28. Customers with multiple failed payments

SELECT c.customer_id, c.full_name, COUNT(*) AS failed_count
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
WHERE p.payment_status <> 'Success'
GROUP BY c.customer_id
HAVING failed_count > 1;

-- 29. Payment conversion rate

SELECT 
    (SUM(CASE WHEN p.payment_status='Success' THEN 1 ELSE 0 END) / COUNT(DISTINCT o.order_id) * 100.0) AS success_pct
FROM orders o
LEFT JOIN payments p ON o.order_id = p.order_id;

-- 30. Top delivery partners by avg rating (top 10)

SELECT partner_id, full_name, AVG(rating) AS avg_rating
FROM delivery_partners
GROUP BY partner_id
ORDER BY avg_rating DESC
LIMIT 10;

-- 31. Rolling 7-day revenue (last 30 days)

SELECT DATE(p.payment_time) AS date_day, SUM(p.amount) AS daily_revenue,
       SUM(SUM(p.amount)) OVER (ORDER BY DATE(p.payment_time) ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_7day_revenue
FROM payments p
WHERE p.payment_status='Success' AND p.payment_time >= NOW() - INTERVAL 30 DAY
GROUP BY date_day
ORDER BY date_day ASC;

-- 32. CLTV-ish: lifetime value per customer (top 20)

SELECT c.customer_id, c.full_name,
       COUNT(o.order_id) AS orders_count,
       SUM(p.amount) AS lifetime_value
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN payments p ON o.order_id = p.order_id AND p.payment_status='Success'
GROUP BY c.customer_id
ORDER BY lifetime_value DESC
LIMIT 20;

-- 33. Which cuisine performs best (total revenue)

SELECT r.category AS cuisine, SUM(p.amount) AS revenue
FROM restaurants r
JOIN orders o ON r.restaurant_id = o.restaurant_id
JOIN payments p ON o.order_id = p.order_id AND p.payment_status='Success'
GROUP BY r.category
ORDER BY revenue DESC;

-- 34. Identify items with low availability but high demand

SELECT mi.item_id, mi.item_name, mi.is_available, SUM(oi.quantity) AS qty_sold
FROM menu_items mi
JOIN order_items oi ON mi.item_id = oi.item_id
GROUP BY mi.item_id
HAVING mi.is_available = 0 AND qty_sold > 10;

-- 35. Customers who reviewed negatively (rating <=2)

SELECT DISTINCT c.customer_id, c.full_name, rv.rating, rv.comment
FROM customers c
JOIN reviews rv ON c.customer_id = rv.customer_id
WHERE rv.rating <= 2;

-- 36. Create a view for restaurant revenue summary

CREATE OR REPLACE VIEW v_restaurant_revenue AS
SELECT r.restaurant_id, r.restaurant_name, r.city,
       COUNT(DISTINCT o.order_id) AS total_orders,
       SUM(CASE WHEN p.payment_status='Success' THEN p.amount ELSE 0 END) AS total_revenue,
       COALESCE(AVG(rv.rating),0) AS avg_rating
FROM restaurants r
LEFT JOIN orders o ON r.restaurant_id = o.restaurant_id
LEFT JOIN payments p ON o.order_id = p.order_id
LEFT JOIN reviews rv ON r.restaurant_id = rv.restaurant_id
GROUP BY r.restaurant_id;

-- 37. Query the view (top 10 revenue)

SELECT * FROM v_restaurant_revenue
ORDER BY total_revenue DESC
LIMIT 10;

-- 38. Top N items for a given restaurant (example: restaurant_id = 1, top 5)

SELECT mi.item_name, SUM(oi.quantity) AS sold_qty
FROM menu_items mi
JOIN order_items oi ON mi.item_id = oi.item_id
WHERE mi.restaurant_id = 1
GROUP BY mi.item_id
ORDER BY sold_qty DESC
LIMIT 5;

-- 39. Refunds: orders delivered but payment failed

SELECT o.order_id, o.status, p.payment_status
FROM orders o
LEFT JOIN payments p ON o.order_id = p.order_id
WHERE o.status='Delivered' AND (p.payment_status IS NULL OR p.payment_status <> 'Success');

-- 40. Count orders by status

SELECT status, COUNT(*) AS cnt
FROM orders
GROUP BY status;

-- 41. For each customer, latest order and amount

SELECT c.customer_id, c.full_name,
       (SELECT o2.order_time 
        FROM orders o2 
        WHERE o2.customer_id = c.customer_id 
        ORDER BY o2.order_time DESC LIMIT 1) AS last_order_time,
       (SELECT p2.amount 
        FROM payments p2 
        JOIN orders o3 ON p2.order_id = o3.order_id 
        WHERE o3.customer_id = c.customer_id AND p2.payment_status='Success' 
        ORDER BY p2.payment_time DESC LIMIT 1) AS last_paid_amount
FROM customers c
ORDER BY last_order_time DESC
LIMIT 20;

-- 42. Restaurants with increase/decrease in monthly revenue

SELECT curr.restaurant_id, curr.restaurant_name,
       COALESCE(curr.curr_month_revenue,0) AS curr_month_revenue,
       COALESCE(prev.prev_month_revenue,0) AS prev_month_revenue,
       COALESCE(curr.curr_month_revenue,0) - COALESCE(prev.prev_month_revenue,0) AS diff
FROM (
    SELECT r.restaurant_id, r.restaurant_name, SUM(p.amount) AS curr_month_revenue
    FROM restaurants r
    JOIN orders o ON r.restaurant_id=o.restaurant_id
    JOIN payments p ON o.order_id=p.order_id AND p.payment_status='Success'
    WHERE p.payment_time >= DATE_FORMAT(NOW(),'%Y-%m-01')
    GROUP BY r.restaurant_id
) curr
LEFT JOIN (
    SELECT r.restaurant_id, SUM(p.amount) AS prev_month_revenue
    FROM restaurants r
    JOIN orders o ON r.restaurant_id=o.restaurant_id
    JOIN payments p ON o.order_id=p.order_id AND p.payment_status='Success'
    WHERE p.payment_time >= DATE_FORMAT(NOW() - INTERVAL 1 MONTH, '%Y-%m-01') 
      AND p.payment_time < DATE_FORMAT(NOW(),'%Y-%m-01')
    GROUP BY r.restaurant_id
) prev ON curr.restaurant_id = prev.restaurant_id
ORDER BY diff DESC
LIMIT 20;

-- 43. Suspicious activity: same customer multiple failed payments in last 30 days

SELECT c.customer_id, c.full_name, COUNT(p.payment_id) AS failed_payments
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
WHERE p.payment_status <> 'Success' AND p.payment_time >= NOW() - INTERVAL 30 DAY
GROUP BY c.customer_id
HAVING failed_payments >= 2;

-- 44. Archive old delivered orders

CREATE TABLE IF NOT EXISTS archive_orders LIKE orders;

INSERT INTO archive_orders
SELECT * 
FROM orders
WHERE order_time < NOW() - INTERVAL 365 DAY;

-- 45. Quick counts summary

SELECT
    (SELECT COUNT(*) FROM customers) AS total_customers,
    (SELECT COUNT(*) FROM restaurants) AS total_restaurants,
    (SELECT COUNT(*) FROM orders) AS total_orders,
    (SELECT COUNT(*) FROM deliveries WHERE delivery_status='Delivered') AS total_delivered,
    (SELECT COUNT(*) FROM payments WHERE payment_status='Success') AS total_success_payments;

-- 46. Revenue share by payment method

SELECT payment_method, SUM(amount) AS revenue, COUNT(*) AS tx_count
FROM payments
WHERE payment_status='Success'
GROUP BY payment_method;

-- 47. Average order value per city

SELECT r.city, AVG(o.total_amount) AS avg_order_value
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
GROUP BY r.city
ORDER BY avg_order_value DESC;

-- 48. Customers who gave 5-star ratings the most (top 10)

SELECT c.customer_id, c.full_name, COUNT(*) AS five_star_reviews
FROM customers c
JOIN reviews rv ON c.customer_id = rv.customer_id
WHERE rv.rating = 5
GROUP BY c.customer_id
ORDER BY five_star_reviews DESC
LIMIT 10;

-- 49. Stored procedure: customer summary (orders & total spent)

DROP PROCEDURE IF EXISTS sp_customer_summary;
DELIMITER $$
CREATE PROCEDURE sp_customer_summary (IN p_customer_id INT)
BEGIN
  SELECT c.customer_id, c.full_name,
         COUNT(o.order_id) AS orders_count,
         COALESCE(SUM(p.amount),0) AS total_spent
  FROM customers c
  LEFT JOIN orders o ON c.customer_id = o.customer_id
  LEFT JOIN payments p ON o.order_id = p.order_id AND p.payment_status='Success'
  WHERE c.customer_id = p_customer_id
  GROUP BY c.customer_id;
END$$
DELIMITER ;
