SELECT 'CREATE DATABASE ecom'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'ecom')\gexec

CREATE ROLE airflow LOGIN PASSWORD 'airflow';
ALTER ROLE airflow CREATEDB;
ALTER ROLE airflow CREATEROLE;
ALTER ROLE airflow SUPERUSER;
GRANT ALL PRIVILEGES ON DATABASE airflow TO airflow;

\c ecom

CREATE SCHEMA IF NOT EXISTS landing;
SET search_path TO landing;

DO $$ BEGIN
    CREATE ROLE transform;
EXCEPTION WHEN DUPLICATE_OBJECT THEN
    RAISE NOTICE 'Role transform already exists.';
END $$;

-- Create the `dbt` user and assign to the `transform` role
DO $$ BEGIN
    CREATE ROLE dbt WITH LOGIN PASSWORD 'dbtPassword123';
EXCEPTION WHEN DUPLICATE_OBJECT THEN
    RAISE NOTICE 'Role dbt already exists.';
END $$;

GRANT transform TO dbt;
ALTER ROLE transform WITH SUPERUSER;