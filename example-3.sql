
--	SQL Example 3

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