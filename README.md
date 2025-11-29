🍽️ Food Delivery Database Project

A simulated food delivery platform database containing realistic data for customers, restaurants, menu items, delivery partners, orders, payments, deliveries, and reviews. This project is ideal for practicing SQL queries, analytics, reporting, and data visualization.

📂 Database Structure

The database contains the following tables:

   Table Name	                                          Description

    customers	                  Stores customer information (name, email, phone, address, signup date)
   restaurants	               Stores restaurant information (name, category, city, rating, created date)
    menu_items	                      Stores menu items for each restaurant, price, availability
 delivery_partners	                 Stores delivery partner details (name, vehicle, rating)
     orders	                    Stores orders placed by customers with restaurant and delivery partner
   order_items	                         Stores items for each order with quantity and price
   deliveries	                         Tracks order delivery status, delivery time, and fee
   payments	                           Tracks payment method, amount, status, and timestamp
   reviews	                              Customer reviews for restaurants, linked to orders

🗂️ Sample Relationships

orders.customer_id → customers.customer_id
orders.restaurant_id → restaurants.restaurant_id
orders.partner_id → delivery_partners.partner_id
order_items.order_id → orders.order_id
order_items.item_id → menu_items.id
deliveries.order_id → orders.order_id
deliveries.partner_id → delivery_partners.partner_id
payments.order_id → orders.order_id
reviews.order_id → orders.order_id
reviews.customer_id → customers.customer_id
reviews.restaurant_id → restaurants.restaurant_id
