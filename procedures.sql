CREATE OR REPLACE PROCEDURE transfer_money(from_account INT, to_account INT, transfer_amount NUMERIC)
LANGUAGE plpgsql
AS $$
DECLARE
    current_balance NUMERIC;
BEGIN
    IF transfer_amount <= 0 THEN
        RAISE EXCEPTION 'Amount must be positive';
    END IF;

    SELECT balance INTO current_balance
    FROM accounts
    WHERE account_id = from_account
    FOR UPDATE;

    IF current_balance IS NULL THEN
        RAISE EXCEPTION 'Account % not found', from_account;
    END IF;

    IF current_balance < transfer_amount THEN
        RAISE EXCEPTION 'Insufficient funds: balance is %', current_balance;
    END IF;

    UPDATE accounts SET balance = balance - transfer_amount WHERE account_id = from_account;
    UPDATE accounts SET balance = balance + transfer_amount WHERE account_id = to_account;

    INSERT INTO transactions (account_id, amount, category, created_at) VALUES
        (from_account, -transfer_amount, 'transfer', NOW()),
        (to_account,    transfer_amount, 'transfer', NOW());
END;
$$;