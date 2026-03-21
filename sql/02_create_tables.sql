-- Create the main table to store all customer churn data from the CSV file
CREATE TABLE telco_churn (
    customerID VARCHAR(50) PRIMARY KEY,
    gender VARCHAR(10) NOT NULL,
    SeniorCitizen BOOLEAN NOT NULL,
    Partner BOOLEAN NOT NULL,
    Dependents BOOLEAN NOT NULL,
    tenure INT NOT NULL,
    PhoneService BOOLEAN NOT NULL,
    MultipleLines BOOLEAN NOT NULL,
    InternetService VARCHAR(20) NOT NULL,
    OnlineSecurity BOOLEAN NOT NULL,
    OnlineBackup BOOLEAN NOT NULL,
    DeviceProtection BOOLEAN NOT NULL,
    TechSupport BOOLEAN NOT NULL,
    StreamingTV BOOLEAN NOT NULL,
    StreamingMovies BOOLEAN NOT NULL,
    Contract VARCHAR(20) NOT NULL,
    PaperlessBilling BOOLEAN NOT NULL,
    PaymentMethod VARCHAR(50) NOT NULL,
    MonthlyCharges DECIMAL(10,2) NOT NULL,
    TotalCharges DECIMAL(10,2) NOT NULL,
    Churn BOOLEAN NOT NULL
);

-- Load data from the CSV file into the 'telco_churn' table
-- Note: path must be accessible by PostgreSQL server
COPY telco_churn
FROM 'D:\Data_analyst\telco_churn_project\data\processed\Telco_Customer_Churn_Cleaned.csv'
DELIMITER ','
CSV HEADER;

-- Create the customers table to store basic customer demographic information
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    gender VARCHAR(10) NOT NULL,
    senior_citizen BOOLEAN NOT NULL,
    partner BOOLEAN NOT NULL,
    dependents BOOLEAN NOT NULL,
    tenure INT NOT NULL,
    churn BOOLEAN NOT NULL
);

-- Create a lookup table for different types of contracts
CREATE TABLE contract_types (
    contract_id SERIAL PRIMARY KEY,
    contract_name VARCHAR(20) UNIQUE NOT NULL
);

-- Create a lookup table for available payment methods
CREATE TABLE payment_methods (
    payment_id SERIAL PRIMARY KEY,
    payment_name VARCHAR(50) UNIQUE NOT NULL
);

-- Create a lookup table for internet service types
CREATE TABLE internet_services (
    internet_service_id SERIAL PRIMARY KEY,
    service_name VARCHAR(20) UNIQUE NOT NULL
);

-- Create the billing table to store customer billing and payment information
CREATE TABLE billing (
    billing_id SERIAL PRIMARY KEY,
    customer_id VARCHAR(50) UNIQUE,
    contract_id INT NOT NULL,
    payment_id INT NOT NULL,
    paperless_billing BOOLEAN NOT NULL,
    monthly_charges DECIMAL(10,2) NOT NULL,
    total_charges DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (contract_id) REFERENCES contract_types(contract_id),
    FOREIGN KEY (payment_id) REFERENCES payment_methods(payment_id)
);

-- Create the services table to store customer service subscriptions
CREATE TABLE services (
    service_id SERIAL PRIMARY KEY,
    customer_id VARCHAR(50) UNIQUE,
    phone_service BOOLEAN NOT NULL,
    multiple_lines BOOLEAN NOT NULL,
    internet_service_id INT NOT NULL,
    online_security BOOLEAN NOT NULL,
    online_backup BOOLEAN NOT NULL,
    device_protection BOOLEAN NOT NULL,
    tech_support BOOLEAN NOT NULL,
    streaming_tv BOOLEAN NOT NULL,
    streaming_movies BOOLEAN NOT NULL,

    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (internet_service_id) REFERENCES internet_services(internet_service_id)
);

-- Insert unique contract types from the telco_churn table into the contract_types table
INSERT INTO contract_types (contract_name)
SELECT DISTINCT Contract
FROM telco_churn
ORDER BY Contract
ON CONFLICT (contract_name) DO NOTHING;

-- Insert unique payment methods from the telco_churn table into the payment_methods table
INSERT INTO payment_methods (payment_name)
SELECT DISTINCT PaymentMethod
FROM telco_churn
ORDER BY PaymentMethod
ON CONFLICT (payment_name) DO NOTHING;

-- Insert unique internet service types from the telco_churn table into the internet_services table
INSERT INTO internet_services (service_name)
SELECT DISTINCT InternetService
FROM telco_churn
ORDER BY InternetService
ON CONFLICT (service_name) DO NOTHING;

-- Insert customer demographic data from the telco_churn table into the customers table
INSERT INTO customers (
    customer_id,
    gender,
    senior_citizen,
    partner,
    dependents,
    tenure,
    churn
)
SELECT
    customerID,
    gender,
    SeniorCitizen,
    Partner,
    Dependents,
    tenure,
    Churn
FROM telco_churn;

-- Insert billing information by joining contract and payment lookup tables
INSERT INTO billing (
    customer_id,
    contract_id,
    payment_id,
    paperless_billing,
    monthly_charges,
    total_charges
)
SELECT
    t.customerID,
    ct.contract_id,
    pm.payment_id,
    t.PaperlessBilling,
    t.MonthlyCharges,
    t.TotalCharges
FROM telco_churn t
JOIN contract_types ct
    ON t.Contract = ct.contract_name
JOIN payment_methods pm
    ON t.PaymentMethod = pm.payment_name;

-- Insert customer service subscription data into the services table
INSERT INTO services (
    customer_id,
    phone_service,
    multiple_lines,
    internet_service_id,
    online_security,
    online_backup,
    device_protection,
    tech_support,
    streaming_tv,
    streaming_movies
)
SELECT
    t.customerID,
    t.PhoneService,
    t.MultipleLines,
    i.internet_service_id,
    t.OnlineSecurity,
    t.OnlineBackup,
    t.DeviceProtection,
    t.TechSupport,
    t.StreamingTV,
    t.StreamingMovies
FROM telco_churn t
JOIN internet_services i
    ON t.InternetService = i.service_name;

-- Create a table to store the churn risk scores for each customer
CREATE TABLE churn_risk_score (
    customer_id VARCHAR(50) PRIMARY KEY,
    churn_probability FLOAT,
    risk_level VARCHAR(10),
    expected_loss FLOAT,

    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Create a table to store the results of retention strategy simulations
CREATE TABLE retention_simulation_results (
    strategy VARCHAR(50),
    discount_months INT,
    discount_rate VARCHAR(10),
    retention_rate VARCHAR(10),
    target_customers INT,
    total_cost FLOAT,
    saved_revenue FLOAT,
    roi FLOAT
);