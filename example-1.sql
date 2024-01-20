
-- SQL Example 1

-- List customers along with their total purchases and country information


SELECT customer.CustomerId, CONCAT(customer.FirstName, ' ', customer.LastName) AS CustomerName,
       customer.Country, SUM(invoice.Total) AS TotalPurchases
FROM customer
INNER JOIN invoice ON customer.CustomerId = invoice.CustomerId
GROUP BY customer.CustomerId
ORDER BY TotalPurchases DESC
LIMIT 10;


