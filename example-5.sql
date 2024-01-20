
-- SQL Example 5	

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

