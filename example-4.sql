
-- SQL Example 4

-- Find the top customer in terms of total spending for each country

SELECT
    Country,
    CustomerName,
    TotalSpending
FROM
    (
        SELECT
            c.Country,
            CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
            RANK() OVER (PARTITION BY c.Country ORDER BY TotalSpending DESC) AS Ranking,
            TotalSpending
        FROM
            customer c
        LEFT JOIN
            (
                SELECT
                    i.CustomerId,
                    SUM(ii.UnitPrice * ii.Quantity) AS TotalSpending
                FROM
                    invoice i
                INNER JOIN
                    invoiceline ii ON i.InvoiceId = ii.InvoiceId
                GROUP BY
                    i.CustomerId
            ) AS s ON c.CustomerId = s.CustomerId
    ) AS ranked_customers
WHERE
    Ranking = 1;
	