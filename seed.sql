INSERT INTO customers (full_name, city, referred_by) VALUES
    ('Ahmed Hassan',  'Riyadh', NULL),
    ('Sara Ali',      'Jeddah', 1),
    ('Omar Khaled',   'Riyadh', 1),
    ('Lina Mansour',  'Dammam', 2),
    ('Youssef Adel',  'Jeddah', 4),
    ('Mona Fathy',    'Riyadh', NULL);

INSERT INTO accounts (customer_id, account_type, balance) VALUES
    (1, 'checking', 12500.00),
    (1, 'savings',  40000.00),
    (2, 'checking',  3200.00),
    (3, 'checking',   870.50),
    (4, 'checking', 15400.00),
    (4, 'savings',   9000.00),
    (5, 'checking',   220.00),
    (6, 'checking',  6100.00);

-- 300 random purchases over the last 6 months
INSERT INTO transactions (account_id, amount, category, created_at)
SELECT
    floor(random() * 8)::int + 1,
    -round((random() * 500 + 5)::numeric, 2),
    (ARRAY['groceries', 'restaurants', 'fuel', 'shopping', 'bills', 'travel'])[floor(random() * 6)::int + 1],
    NOW() - random() * INTERVAL '180 days'
FROM generate_series(1, 300);

-- a monthly salary into every checking account
INSERT INTO transactions (account_id, amount, category, created_at)
SELECT a.account_id, 8000, 'salary', date_trunc('month', NOW()) - m * INTERVAL '1 month' + INTERVAL '24 days'
FROM accounts a, generate_series(1, 6) AS m
WHERE a.account_type = 'checking';