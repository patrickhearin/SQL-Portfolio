
-- SQL Example 6

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