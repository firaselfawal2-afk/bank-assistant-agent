import os
import psycopg
from dotenv import load_dotenv

load_dotenv()


def run_query(sql, params=None):
    with psycopg.connect(os.getenv("DATABASE_URL")) as conn:
        with conn.cursor() as cur:
            cur.execute(sql, params)
            return cur.fetchall()


if __name__ == "__main__":
    print(run_query("SELECT full_name, city FROM customers WHERE city = %s", ("Riyadh",)))