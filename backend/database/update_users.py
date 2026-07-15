from backend.extensions import db


def update_users_table():

    sql = """

    ALTER TABLE users
    ADD COLUMN IF NOT EXISTS traffic_limit BIGINT DEFAULT 0;

    ALTER TABLE users
    ADD COLUMN IF NOT EXISTS used_traffic BIGINT DEFAULT 0;

    ALTER TABLE users
    ADD COLUMN IF NOT EXISTS status VARCHAR(20)
    DEFAULT 'active';

    ALTER TABLE users
    ADD COLUMN IF NOT EXISTS server_id INTEGER;

    ALTER TABLE users
    ADD COLUMN IF NOT EXISTS created_at TIMESTAMP
    DEFAULT NOW();

    """

    db.session.execute(db.text(sql))
    db.session.commit()
