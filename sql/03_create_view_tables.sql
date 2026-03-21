-- Create a prepared dataset view for churn analysis
CREATE OR REPLACE VIEW churn_feature_dataset AS
SELECT
    c.customer_id,
    c.gender,
    c.senior_citizen,
    c.partner,
    c.dependents,
    c.tenure,
    c.churn,

    -- Tenure Bucket
    CASE
        WHEN c.tenure < 6 THEN '0–5 months'
        WHEN c.tenure <= 12 THEN '6–12 months'
        WHEN c.tenure <= 24 THEN '13–24 months'
        ELSE '25+ months'
    END AS tenure_bucket,

    -- Contract Name
    ct.contract_name,

    -- Payment Method
    pm.payment_name,

    -- Internet Service
    i.service_name AS internet_service,

    -- Billing Info
    b.monthly_charges,
    b.total_charges,
    b.paperless_billing,

    -- Spending Segment
    CASE
        WHEN b.monthly_charges < 40 THEN 'Low Spender'
        WHEN b.monthly_charges <= 70 THEN 'Mid Spender'
        ELSE 'High Spender'
    END AS spending_segment,

    -- Service Count
    (
        CAST(s.phone_service AS INT) +
        CAST(s.multiple_lines AS INT) +
        CAST(s.online_security AS INT) +
        CAST(s.online_backup AS INT) +
        CAST(s.device_protection AS INT) +
        CAST(s.tech_support AS INT) +
        CAST(s.streaming_tv AS INT) +
        CAST(s.streaming_movies AS INT)
    ) AS service_count,

    -- Contract Risk Flag
    CASE
        WHEN ct.contract_name = 'month-to-month' THEN 1
        ELSE 0
    END AS contract_risk_flag,

    -- CLV (Simple Approximation)
    -- CLV = MonthlyCharges × Tenure
    (b.monthly_charges * c.tenure) AS clv,

    -- Revenue at Risk
    -- Revenue hilang jika churn = true
    CASE
        WHEN c.churn = TRUE THEN (b.monthly_charges * 12)
        ELSE 0
    END AS revenue_at_risk

FROM customers c
LEFT JOIN billing b
    ON c.customer_id = b.customer_id
LEFT JOIN contract_types ct
    ON b.contract_id = ct.contract_id
LEFT JOIN payment_methods pm
    ON b.payment_id = pm.payment_id
LEFT JOIN services s
    ON c.customer_id = s.customer_id
LEFT JOIN internet_services i
    ON s.internet_service_id = i.internet_service_id;

-- Create a view that combines features with risk scores for dashboarding
CREATE OR REPLACE VIEW churn_dashboard_dataset AS
SELECT
    f.*,
    r.churn_probability,
    r.risk_level,
    r.expected_loss
FROM churn_feature_dataset f
LEFT JOIN churn_risk_score r
ON f.customer_id = r.customer_id;