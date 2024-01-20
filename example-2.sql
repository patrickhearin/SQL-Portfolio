
-- SQL Example 2

-- List customers who have not made any purchases


SELECT customer.CustomerId, CONCAT(customer.FirstName, ' ', customer.LastName) AS CustomerName
FROM customer
LEFT JOIN invoice ON customer.CustomerId = invoice.CustomerId
WHERE invoice.CustomerId IS NULL;