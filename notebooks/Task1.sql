PRAGMA foreign_keys = ON;

-- Dimension: Date
CREATE TABLE IF NOT EXISTS dim_date (
    date_key        INTEGER PRIMARY KEY,   -- surrogate key (e.g., 20250101 or sequential int)
    date            TEXT NOT NULL,         -- ISO 'YYYY-MM-DD'
    day             INTEGER NOT NULL,
    month           INTEGER NOT NULL,
    quarter         INTEGER NOT NULL,
    year            INTEGER NOT NULL
);

-- Dimension: Product
CREATE TABLE IF NOT EXISTS dim_product (
    product_key     INTEGER PRIMARY KEY,
    product_id_nat  TEXT UNIQUE,           -- natural/business key from source
    product_name    TEXT NOT NULL,
    category        TEXT NOT NULL,
    subcategory     TEXT,
    brand           TEXT
);

-- Dimension: Customer
CREATE TABLE IF NOT EXISTS dim_customer (
    customer_key    INTEGER PRIMARY KEY,
    customer_id_nat TEXT UNIQUE,
    first_name      TEXT,
    last_name       TEXT,
    gender          TEXT,
    age_group       TEXT,
    city            TEXT,
    state           TEXT,
    country         TEXT
);

-- Dimension: Store
CREATE TABLE IF NOT EXISTS dim_store (
    store_key       INTEGER PRIMARY KEY,
    store_id_nat    TEXT UNIQUE,
    store_name      TEXT,
    city            TEXT,
    state           TEXT,
    country         TEXT
);

-- Fact: Sales
CREATE TABLE IF NOT EXISTS fact_sales (
    sales_key       INTEGER PRIMARY KEY,
    date_key        INTEGER NOT NULL,
    product_key     INTEGER NOT NULL,
    customer_key    INTEGER NOT NULL,
    store_key       INTEGER NOT NULL,
    quantity        INTEGER NOT NULL CHECK (quantity >= 0),
    unit_price      REAL NOT NULL CHECK (unit_price >= 0),
    discount_amount REAL DEFAULT 0 CHECK (discount_amount >= 0),
    cost_amount     REAL DEFAULT 0 CHECK (cost_amount >= 0),
    sales_amount    AS (ROUND((quantity * unit_price) - discount_amount, 2)) STORED,

    FOREIGN KEY (date_key)    REFERENCES dim_date(date_key),
    FOREIGN KEY (product_key) REFERENCES dim_product(product_key),
    FOREIGN KEY (customer_key)REFERENCES dim_customer(customer_key),
    FOREIGN KEY (store_key)   REFERENCES dim_store(store_key)
);

-- Helpful indexes for typical queries
CREATE INDEX IF NOT EXISTS idx_fact_sales_date   ON fact_sales(date_key);
CREATE INDEX IF NOT EXISTS idx_fact_sales_prod   ON fact_sales(product_key);
CREATE INDEX IF NOT EXISTS idx_fact_sales_cust   ON fact_sales(customer_key);
CREATE INDEX IF NOT EXISTS idx_fact_sales_store  ON fact_sales(store_key);
