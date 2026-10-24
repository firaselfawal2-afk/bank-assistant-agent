WITH RECURSIVE referral_tree AS (
    -- start: customers nobody referred
    SELECT customer_id, full_name, referred_by, 1 AS level, full_name AS chain
    FROM customers
    WHERE referred_by IS NULL

    UNION ALL

    -- repeat: find people referred by someone already in the tree
    SELECT c.customer_id, c.full_name, c.referred_by, rt.level + 1, rt.chain || ' -> ' || c.full_name
    FROM customers c
    JOIN referral_tree rt ON c.referred_by = rt.customer_id
)
SELECT level, full_name, chain
FROM referral_tree
ORDER BY chain;