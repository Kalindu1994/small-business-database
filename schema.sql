-- Define the transactions table to track customer transactions
CREATE TABLE "transactions" (
    "customer_invoice_id" INTEGER,
    "datetime" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "product_id" INTEGER,
    "price" INTEGER NOT NULL,
    "quantity" INTEGER NOT NULL,
    "total_amount" REAL NOT NULL,
    "amount_paid" REAL NOT NULL,
    "customer_id" INTEGER NOT NULL,
    "status" TEXT NOT NULL CHECK("status" IN ('paid', 'pending_payment')),
    "payment_method" TEXT NOT NULL CHECK("payment_method" IN ('cash', 'debit', 'credit')),
    "transaction_made_by_id" INTEGER,
    PRIMARY KEY ("customer_invoice_id"),
    FOREIGN KEY ("customer_id") REFERENCES "customers"("id"),
    FOREIGN KEY ("transaction_made_by_id") REFERENCES "employees"("id"),
    FOREIGN KEY ("product_id") REFERENCES "inventory"("id")
);

-- Define the inventory table to track available products and their stock
CREATE TABLE "inventory" (
    "id" INTEGER,
    "product_name" TEXT NOT NULL,
    "stock" INT NOT NULL,
    PRIMARY KEY ("id")
);

-- Define the supplier invoices table to track supplier transactions
CREATE TABLE "supplierinvoices" (
    "id" TEXT,
    "invoice_date" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "product_id" INTEGER,
    "cog" REAL NOT NULL,
    "quantity" INTEGER NOT NULL,
    "total_amount" REAL NOT NULL,
    "amount_paid" REAL NOT NULL,
    "supplier_id" INTEGER,
    "status" TEXT NOT NULL CHECK("status" IN ('paid', 'pending_payment')),
    PRIMARY KEY("id"),
    FOREIGN KEY ("product_id") REFERENCES "inventory"("id"),
    FOREIGN KEY ("supplier_id") REFERENCES "suppliers"("id")
);

-- Define the suppliers table to store supplier information
CREATE TABLE "suppliers" (
    "id" INTEGER,
    "company_name" TEXT,
    "company_contact" TEXT,
    "sales_rep_name" TEXT,
    "sales_rep_contact" TEXT,
    PRIMARY KEY("id")
);

-- Define the customers table to store customer information
CREATE TABLE "customers" (
    "id" INTEGER,
    "first_name" TEXT,
    "last_name" TEXT,
    "mobile" TEXT,
    PRIMARY KEY("id")
);

-- Define the returns and refunds table to track product returns and refunds
CREATE TABLE "returns_and_refunds" (
    "id" INTEGER,
    "invoice_id" INTEGER,
    "product_id" INTEGER,
    "refund_amount" REAL,
    PRIMARY KEY("id")
);

-- Define the employees table to store employee information
CREATE TABLE "employees" (
    "id" INTEGER,
    "first_name" TEXT,
    "last_name" TEXT,
    "date_joined" NUMERIC DEFAULT CURRENT_TIMESTAMP,
    "employment_type" TEXT NOT NULL CHECK("employment_type" IN ('full-time', 'part-time', 'contract')),
    "salary" INTEGER,
    PRIMARY KEY("id")
);

-- Create indexes for faster querying
CREATE INDEX "transactions_index" ON "transactions" ("customer_id", "product_id");
CREATE INDEX "supplier_invoices_index" ON "supplierinvoices" ("product_id", "supplier_id");
CREATE INDEX "returns_and_refunds_indexes" ON "returns_and_refunds" ("invoice_id", "product_id");

-- Create views to provide summarized information
-- Create view to provide summarized information of debtors
CREATE VIEW "debtors" AS
SELECT "customer_id", "customer_invoice_id", "total_amount" , "amount_paid", ("total_amount" - "amount_paid") AS "remaining_balance"
FROM "transactions"
WHERE "status" = 'pending_payment'
GROUP BY "customer_id";

-- Create view to provide summarized information of creditors
CREATE VIEW "creditors" AS
SELECT "supplier_id", "id", "total_amount", "amount_paid", ("total_amount" - "amount_paid") AS "remaining_balance"
FROM "supplierinvoices"
WHERE "status" = 'pending_payment'
GROUP BY "supplier_id";

-- Create view to provide summarized information of products when they reach the stock threshold of 5 units
CREATE VIEW "stock_threshold" AS
SELECT "inventory"."id", "product_name", "stock", "supplierinvoices"."supplier_id", "suppliers"."sales_rep_contact"
FROM "inventory"
JOIN "supplier_invoices" ON "supplierinvoices"."product_id" = "inventory"."id"
JOIN "suppliers" ON "suppliers"."id" = "supplierinvoices"."supplier_id"
WHERE "inventory"."stock" < 5;

-- Define triggers to automatically update stock levels
-- Trigger to update stock when a new transaction is made
CREATE TRIGGER "update_stock_after_transaction"
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    UPDATE "inventory"
    SET "stock" = "stock" - NEW."quantity"
    WHERE "id" = NEW."product_id";
END;

-- Trigger to update stock after a supplier invoice
CREATE TRIGGER "update_inventory_stock_after_supplier_invoice"
AFTER INSERT ON "supplierinvoices"
BEGIN
    UPDATE "inventory"
    SET stock = "stock" + "NEW.quantity"
    WHERE "id" = NEW."product_id";
END;


