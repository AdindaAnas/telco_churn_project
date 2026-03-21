# Telco Customer Churn Analysis

## Project Overview

Customer churn merupakan salah satu tantangan utama dalam industri telekomunikasi. Ketika pelanggan berhenti menggunakan layanan, perusahaan tidak hanya kehilangan revenue tetapi juga harus mengeluarkan biaya tambahan untuk memperoleh pelanggan baru.

Project ini bertujuan untuk:
- Menganalisis faktor-faktor yang mempengaruhi churn pelanggan
- Membangun model machine learning untuk memprediksi churn
- Mengestimasi potensi kerugian bisnis akibat churn
- Mensimulasikan strategi retensi pelanggan untuk memaksimalkan ROI

Dataset yang digunakan adalah **Telco Customer Churn Dataset** dengan 7,043 pelanggan dan 21 fitur.

### Data Source
Dataset diperoleh dari Kaggle:
https://www.kaggle.com/datasets/blastchar/telco-customer-churn

---

# Business Objectives

1. Mengidentifikasi faktor utama yang menyebabkan churn
2. Memprediksi pelanggan yang berisiko churn
3. Mengestimasi revenue loss akibat churn
4. Mengembangkan strategi retensi yang memberikan ROI positif

---

# Project Workflow

Project ini terdiri dari beberapa tahap utama:

### 1. Data Cleaning
Membersihkan dataset dari missing values dan inkonsistensi data.

### 2. Database Design
Membangun relational database menggunakan PostgreSQL dengan struktur:

- customers
- billing
- services
- contract_types
- payment_methods
- internet_services

### 3. Exploratory Data Analysis (EDA)

Analisis dilakukan untuk memahami pola churn pelanggan.

Beberapa insight utama:

- Churn rate: **26.5%**
- Pelanggan **month-to-month contract** memiliki churn tertinggi
- Pelanggan **tenure rendah lebih rentan churn**
- Pelanggan dengan **monthly charges tinggi lebih berisiko churn**

---

### 4. Customer Segmentation

Segmentasi pelanggan dilakukan berdasarkan:

- Tenure Bucket
- Spending Segment
- Service Usage
- Contract Risk
- Customer Lifetime Value (CLV proxy)
- Revenue at Risk

Insight utama:

- **High Spender memiliki churn rate tertinggi**
- **Customer dengan sedikit layanan lebih mudah churn**
- **High Spender menyumbang revenue at risk terbesar**

---

### 5. Machine Learning Model

Beberapa model dibandingkan:

- Logistic Regression
- Random Forest
- XGBoost

Pendekatan untuk menangani class imbalance:

- Baseline
- Class Weighting
- SMOTE

Best Model:

Random Forest

Performance:

ROC-AUC: 0.844  
PR-AUC: 0.655  
Recall: 0.826

---

### 6. Business Impact Evaluation

Model digunakan untuk menghitung:

- Churn Probability
- Risk Level
- Expected Financial Loss

Dataset hasil scoring disimpan dalam table: `churn_risk_score`

**Example Output**: `churn_risk_score`

| customer_id | churn_probability | risk_level | expected_loss |
|-------------|------------------|-----------|--------------|
| 7590-VHVEG | 0.567 | Medium | 203.23 |
| 5575-GNVDE | 0.056 | Low | 38.22 |
| 3668-QPYBK | 0.511 | Medium | 329.90 |
| 7795-CFOCW | 0.044 | Low | 22.21 |
| 9237-HQITU | 0.621 | High | 526.94 |

---

### 7. Retention Strategy Simulation

Simulasi dilakukan untuk mengukur ROI dari strategi retensi pelanggan.

Beberapa skenario yang diuji:

- Discount: 5%, 10%, 15%
- Program duration: 3 months, 6 months
- Retention success rate: 10%, 20%, 30%

Best Strategy:

Target: High Risk + High Revenue customers  
Discount: 5%  
Duration: 3 months  

ROI: **15.93**

**Catatan:**
Nilai ROI yang dihasilkan merupakan estimasi berbasis simulasi dan beberapa asumsi yang disederhanakan. Dalam implementasi nyata, biaya operasional tambahan serta variasi perilaku pelanggan dapat mempengaruhi hasil aktual dari program retensi.

---

# Key Business Insights

- Pelanggan dengan **kontrak month-to-month** memiliki risiko churn paling tinggi dibandingkan kontrak jangka panjang.
- Segmen **High Spender** menyumbang **revenue at risk terbesar**, sehingga menjadi prioritas utama dalam strategi retensi.
- Pelanggan yang menggunakan **lebih banyak layanan cenderung memiliki tingkat churn lebih rendah**, menunjukkan adanya efek customer stickiness.
- Strategi retensi yang menargetkan pelanggan dengan **risiko churn tinggi dan nilai revenue tinggi** berpotensi menghasilkan **ROI hingga 15,9x**, bahkan dengan insentif kecil berupa **diskon 5% selama 3 bulan**.

---

# Tech Stack

Python  
Pandas  
Scikit-learn  
XGBoost  
PostgreSQL  
SQLAlchemy  
Seaborn & Matplotlib  

---

# Project Structure

telco_churn_project
│
├── data
│   ├── raw
│   └── processed
│
├── notebooks
│   ├── 01_eda.ipynb
│   ├── 02_customer_segmentation.ipynb
│   ├── 03_modelling.ipynb
│   └── 04_business_recommendation.ipynb
│
├── sql
│   ├── 01_create_database.sql
│   ├── 02_create_tables.sql
│   └── 03_create_view_tables.sql
│
├── src
│   ├── clean_data.py
│   └── database.py
│
├── requirements.txt
├── README.md
└── .gitignore