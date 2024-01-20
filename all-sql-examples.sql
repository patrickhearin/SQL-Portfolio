
-- Example 1

-- List customers along with their total purchases and country information
SELECT customer.CustomerId, CONCAT(customer.FirstName, ' ', customer.LastName) AS CustomerName,
       customer.Country, SUM(invoice.Total) AS TotalPurchases
FROM customer
INNER JOIN invoice ON customer.CustomerId = invoice.CustomerId
GROUP BY customer.CustomerId
ORDER BY TotalPurchases DESC
LIMIT 10;

-- Example 2


-- List customers who have not made any purchases
SELECT customer.CustomerId, CONCAT(customer.FirstName, ' ', customer.LastName) AS CustomerName
FROM customer
LEFT JOIN invoice ON customer.CustomerId = invoice.CustomerId
WHERE invoice.CustomerId IS NULL;

-- Example 3


-- Find invoices with more than one genre in their purchased tracks
SELECT
    i.InvoiceId,
    COUNT(DISTINCT t.GenreId) AS NumberOfGenres
FROM
    invoice i
INNER JOIN
    invoiceline ii ON i.InvoiceId = ii.InvoiceId
INNER JOIN
    track t ON ii.TrackId = t.TrackId
GROUP BY
    i.InvoiceId
HAVING
    NumberOfGenres > 1;


-- Example 4

	

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
	
	
	
	
-- Example 5
	
	

-- Find customers with similar taste based on shared genres of purchased tracks
SELECT
    c1.CustomerId AS Customer1,
    CONCAT(c1.FirstName, ' ', c1.LastName) AS Customer1Name,
    c2.CustomerId AS Customer2,
    CONCAT(c2.FirstName, ' ', c2.LastName) AS Customer2Name,
    COUNT(DISTINCT t.GenreId) AS SharedGenres
FROM
    customer c1
INNER JOIN
    customer c2 ON c1.CustomerId < c2.CustomerId
INNER JOIN
    invoice i1 ON c1.CustomerId = i1.CustomerId
INNER JOIN
    invoice i2 ON c2.CustomerId = i2.CustomerId
INNER JOIN
    invoiceline ii1 ON i1.InvoiceId = ii1.InvoiceId
INNER JOIN
    invoiceline ii2 ON i2.InvoiceId = ii2.InvoiceId
INNER JOIN
    track t ON ii1.TrackId = t.TrackId AND ii2.TrackId = t.TrackId
GROUP BY
    c1.CustomerId, c2.CustomerId
HAVING
    SharedGenres > 0
ORDER BY
    SharedGenres DESC;



-- Example 6


-- Calculate the cumulative sales growth percentage for each genre
SELECT
    g.Name AS GenreName,
    i.InvoiceDate,
    SUM(ii.UnitPrice * ii.Quantity) AS CumulativeSales,
    100 * (
        SUM(SUM(ii.UnitPrice * ii.Quantity)) OVER (PARTITION BY g.GenreId ORDER BY i.InvoiceDate)
        / MAX(SUM(ii.UnitPrice * ii.Quantity)) OVER (PARTITION BY g.GenreId)
    ) AS CumulativeSalesGrowth
FROM
    genre g
INNER JOIN
    track t ON g.GenreId = t.GenreId
INNER JOIN
    invoiceline ii ON t.TrackId = ii.TrackId
INNER JOIN
    invoice i ON ii.InvoiceId = i.InvoiceId
GROUP BY
    g.GenreId, i.InvoiceDate
ORDER BY
    g.GenreId, i.InvoiceDate;