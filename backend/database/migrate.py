import os
import psycopg2

from backend.config import Config


def run_migrations():

    db_url = Config.SQLALCHEMY_DATABASE_URI

    print("Running database migrations...")

    conn = psycopg2.connect(db_url)

    cur = conn.cursor()

    migration_path = os.path.join(
        os.path.dirname(__file__),
        "migrations",
        "001_add_user_columns.sql"
    )

    with open(migration_path, "r") as file:
        sql = file.read()

    cur.execute(sql)

    conn.commit()

    cur.close()
    conn.close()

    print("Migration completed")


if __name__ == "__main__":
    run_migrations()
