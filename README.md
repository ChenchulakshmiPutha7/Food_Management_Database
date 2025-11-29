🍽️ Food Delivery Database Project

A simulated food delivery platform database containing realistic data for customers, restaurants, menu items, delivery partners, orders, payments, deliveries, and reviews. This project is ideal for practicing SQL queries, analytics, reporting, and data visualization.

🗂️ Database Structure
1. Customers

Stores details of customers including their contact info and addresses.
Columns: customer_id, full_name, email, phone, address, created_at

2. Restaurants

Information about restaurants, their cuisine type, city, and rating.
Columns: restaurant_id, restaurant_name, category, city, rating, created_at

3. Menu Items

Lists all menu items for each restaurant along with price and availability.
Columns: item_id, restaurant_id, item_name, price, is_available

4. Delivery Partners

Stores details of delivery partners including vehicle and rating.
Columns: partner_id, full_name, phone, vehicle, rating

5. Orders

Stores order-level information, linking customers, restaurants, and delivery partners.
Columns: order_id, customer_id, restaurant_id, order_time, total_amount, status, partner_id

6. Order Items

Tracks each item within an order including quantity and price.
Columns: order_item_id, order_id, item_id, quantity, price

7. Deliveries

Tracks delivery status, times, and fees for each order.
Columns: delivery_id, order_id, partner_id, delivery_time, delivery_status, delivery_fee

8. Payments

Stores payment details for each order.
Columns: payment_id, order_id, amount, payment_method, payment_status, payment_time

9. Reviews

Stores customer feedback for each order and restaurant.
Columns: review_id, order_id, customer_id, restaurant_id, rating, comment, review_time

🔗 Relationships

orders links customers, restaurants, and delivery_partners

order_items links orders and menu_items

deliveries links orders and delivery_partners

payments links to orders

reviews link orders, customers, and restaurants

🛠️ Features

Track customers and their order history.

Manage restaurant details, menu items, and ratings.

Monitor order and delivery statuses in real-time.

Record payments and their status (success, pending, failed).

Collect and analyze customer reviews and ratings.

📊 Sample Data

50+ customers

50 restaurants

50 menu items per restaurant

50 delivery partners

50 orders with order items, payments, deliveries, and reviews

💡 Use Cases

Customer purchase behavior analysis

Restaurant performance tracking

Delivery efficiency optimization

Payment success/failure analysis

Review sentiment analysis

📂 Suggested GitHub Folder Structure

Food_Management_Database/

│
├─ README.md
├─ Food_Management_Schema.sql          # Database creation scripts
├─ Food_Management_Insert_Data.sql     # Insert statements for testing
└─ Food_Management_Queries.sql         # Queries
