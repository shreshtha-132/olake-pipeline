-- Updates pending order
UPDATE ecommerce.orders SET status = 'COMPLETED' WHERE customer_id = 102;

-- Deletes a cancelled order
DELETE FROM ecommerce.orders WHERE order_id = 4;

-- Inserts a new order
INSERT INTO ecommerce.orders (order_id, customer_id, amount, status) VALUES
(16, 116, 420.00, 'COMPLETED');
