-- Simulate CDC changes (Update, Delete, Insert)
UPDATE ecommerce.orders SET status = 'COMPLETED' WHERE customer_id = 102;
UPDATE ecommerce.orders SET amount = 350.00 WHERE customer_id = 103;

DELETE FROM ecommerce.orders WHERE customer_id = 104;

INSERT INTO ecommerce.orders (customer_id, amount, status) VALUES
(116, 420.00, 'COMPLETED');
