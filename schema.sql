DROP TABLE IF EXISTS transactions, accounts, customers;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    full_name   TEXT NOT NULL,
    city        TEXT,
    referred_by INT REFERENCES customers(customer_id)
);

CREATE TABLE accounts (
    account_id   SERIAL PRIMARY KEY,
    customer_id  INT NOT NULL REFERENCES customers(customer_id),
    account_type TEXT NOT NULL,
    balance      NUMERIC(12, 2) NOT NULL DEFAULT 0
);

CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    account_id     INT NOT NULL REFERENCES accounts(account_id),
    amount         NUMERIC(12, 2) NOT NULL,
    category       TEXT,
    created_at     TIMESTAMP NOT NULL
);