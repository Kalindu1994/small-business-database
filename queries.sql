-- Hire a new employee
INSERT INTO "employees" ("first_name", "last_name", "employment_type", "salary") VALUES ('Kalindu', 'Liyanage', 'full-time', 50000);

-- Add a new product to the inventory
INSERT INTO "inventory" ("product_name", "stock") VALUES ('4 litre paint', 0);

-- Add a new supplier to the database
INSERT INTO "suppliers" ("company_name", "company_contact", "sales_rep_name", "sales_rep_contact") VALUES ('DULUX', '077-315-4488', 'Gayan', '011-240-5308');

-- Create a new supplier invoice
INSERT INTO "supplierinvoices" ("id", "invoice_date", "product_id", "cog", "quantity", "total_amount", "amount_paid", "supplier_id", "status", "transaction_made_by_id") VALUES ('INV001', '2024-02-20 10:00:00', 1, 17.0, 10, 170.0, 70.0, 1, 'pending_payment', 1);

-- Add a new customer to the database
INSERT INTO "customers" ("first_name", "last_name", "mobile") VALUES ('Maneesha', 'Rambukwella', '548-883-4488');

-- Insert a new transaction record
INSERT INTO "transactions" ("datetime", "product_id", "price", "quantity", "total_amount", "amount_paid", "customer_id", "status", "payment_method") VALUES ('2024-02-20 10:00:00', 1, 20.0, 5, 10.0, 60.0, 1, 'pending_payment', 'credit');

-- Update the status of a transaction to 'paid'
UPDATE "transactions" SET "status" = 'paid' WHERE "customer_invoice_id" = 1;

-- Mark a supplier invoice as paid
UPDATE "supplierinvoices" SET "status" = 'paid' WHERE id = 1;

-- Update the mobile number of a customer
UPDATE "customers" SET "mobile" = '548-883-8488' WHERE id = 1;

-- Increase the salary of an employee
UPDATE "employees" SET "salary" = 60000 WHERE id = 1;

-- Retrieve all transactions made by a specific customer
SELECT * FROM "transactions" WHERE "customer_id" = 1;

-- Retrieve all products in the inventory with their current stock levels
SELECT * FROM "inventory";

-- Retrieve details of all supplier invoices that are pending payment
SELECT * FROM "supplierinvoices" WHERE "status" = 'pending_payment';

-- Retrieve information about a specific customer
SELECT * FROM "customers" WHERE "id" = 1;

-- Retrieve details of all employees who are full-time
SELECT * FROM "employees" WHERE "employment_type" = 'full-time';

-- Delete a transaction record
DELETE FROM "transactions" WHERE "customer_invoice_id" = 1;

-- Remove a product from the inventory
DELETE FROM "inventory" WHERE "id" = 1;

-- Remove a supplier invoice from the database
DELETE FROM "supplierinvoices" WHERE "id" = 1;

-- Delete a customer record
DELETE FROM "customers" WHERE 'id' = 1;

-- Terminate an employee's record
DELETE FROM "employees" WHERE "id" = 1;
