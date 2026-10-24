SELECT
    c.full_name,
    COUNT(*)        AS purchases,
    -SUM(t.amount)  AS total_spent
FROM transactions t
JOIN accounts  a ON a.account_id  = t.account_id
JOIN customers c ON c.customer_id = a.customer_id
WHERE t.amount < 0
GROUP BY c.full_name
ORDER BY total_spent DESC;