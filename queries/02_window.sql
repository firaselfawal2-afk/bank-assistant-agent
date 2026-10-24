WITH monthly AS (
    SELECT
        c.full_name,
        date_trunc('month', t.created_at)::date AS month,
        -SUM(t.amount) AS spent
    FROM transactions t
    JOIN accounts  a ON a.account_id  = t.account_id
    JOIN customers c ON c.customer_id = a.customer_id
    WHERE t.amount < 0
    GROUP BY c.full_name, month
)
SELECT
    month,
    full_name,
    spent,
    RANK() OVER (PARTITION BY month ORDER BY spent DESC)      AS rank_in_month,
    SUM(spent) OVER (PARTITION BY full_name ORDER BY month)   AS running_total
FROM monthly
ORDER BY month, rank_in_month;