from db import run_query


def get_balance(customer_name: str) -> list:
    """Get all accounts and balances for a customer."""
    rows = run_query(
        """
        SELECT a.account_id, a.account_type, a.balance
        FROM accounts a
        JOIN customers c ON c.customer_id = a.customer_id
        WHERE c.full_name ILIKE %s
        """,
        (f"%{customer_name}%",),
    )
    return [{"account_id": r[0], "type": r[1], "balance": float(r[2])} for r in rows]


def get_spending_summary(customer_name: str, months: int = 3) -> list:
    """Get a customer's total spending per category over the last N months."""
    rows = run_query(
        """
        SELECT t.category, -SUM(t.amount) AS spent
        FROM transactions t
        JOIN accounts  a ON a.account_id  = t.account_id
        JOIN customers c ON c.customer_id = a.customer_id
        WHERE c.full_name ILIKE %s
          AND t.amount < 0
          AND t.created_at >= NOW() - make_interval(months => %s)
        GROUP BY t.category
        ORDER BY spent DESC
        """,
        (f"%{customer_name}%", months),
    )
    return [{"category": r[0], "spent": float(r[1])} for r in rows]


if __name__ == "__main__":
    print(get_balance("lina"))
    print(get_spending_summary("lina", 3))