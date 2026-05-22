# EliteStores — End-to-End Sales Analytics Project

A complete data analytics project built on a fictional e-commerce dataset. The project covers the full analytics pipeline — from database design and Python EDA to an interactive web dashboard and a business intelligence report — using the same 8-table dataset throughout.

**Prepared by:** Rohit Godshelwar  
**Data period:** Jan – Jun 2024  
**Tools:** MySQL · Python · Streamlit · Power BI

---


## Dataset Overview

The dataset consists of 8 related tables covering the full e-commerce lifecycle:

| Table | Description | Rows |
|---|---|---|
| orders | Order transactions with status | 12 |
| customers | Customer profiles with city | 10 |
| order_items | Line items per order | 15 |
| products | Product catalogue with pricing | 10 |
| categories | Product category mapping | 5 |
| payments | Payment records with mode and status | 12 |
| shipping | Delivery tracking with estimated vs actual dates | 12 |
| reviews | Customer ratings per product | 8 |

---

## Layer 1 — MySQL Database

Designed a normalized relational schema in MySQL (3NF) with:

- Primary keys on all tables
- Foreign key constraints enforcing referential integrity
- ENUM constraints on `order_status` and `payment_status`
- Indexes on frequently joined columns

**Relationships:**
- `orders` → `customers` (many-to-one)
- `order_items` → `orders` (many-to-one)
- `order_items` → `products` (many-to-one)
- `products` → `categories` (many-to-one)
- `payments` → `orders` (one-to-one)
- `shipping` → `orders` (one-to-one)
- `reviews` → `products` (many-to-one)

---

## Layer 2 — Python EDA

Exploratory analysis using **Pandas**, **Plotly** and **Matplotlib** inside a Jupyter notebook covering:

- Revenue distribution across months, categories and cities
- Payment mode analysis and customer segmentation
- Outlier detection and missing value checks
- Correlation between order value and delivery performance
- Product-level revenue contribution analysis

**Key libraries:** `pandas` `plotly` `matplotlib` `seaborn` `numpy`

---

## Layer 3 — Streamlit Dashboard

An interactive web app built with **Streamlit** and **Plotly** that allows users to explore the EliteStores data with live filters.

**Features:**
- Revenue trend chart by month
- Category and payment mode breakdown
- City-level order distribution
- Top products ranked by revenue
- Real-time KPI cards
<img width="1917" height="918" alt="image" src="https://github.com/user-attachments/assets/c3e6ba55-7686-4c82-aead-2b3fa1680937" />

---

## Layer 4 — Power BI Report

A 2-page business intelligence report built in Power BI Desktop with a Deloitte-style dark sidebar layout.

### Page 1 — Visuals Dashboard

**KPI Sidebar (5 cards):**
- Total Revenue: ₹3,80,281
- Total Orders: 12
- Avg Order Value: ₹38,028
- Delivery Rate: 66.67%
- MoM Growth %: dynamic (updates with date slicer)

**Charts:**
- Revenue by Month (column chart) — January peak at ₹1.95L
- Revenue by Category (donut) — Electronics 88%, Clothing 9%
- Payment Method Split (donut) — UPI 46%, Credit Card 42%
- Orders by City (bar chart) — 10 cities, Delhi and Mumbai lead
- Top Products by Revenue (table) — MacBook Air M2 and Galaxy S23 drive 73% of revenue

**Slicers:** Payment Date (Between) · Category (Dropdown) · Order Status (List)
<img width="1919" height="1008" alt="image" src="https://github.com/user-attachments/assets/6291e2c2-cff1-4594-8d2c-de67874c926b" />



### Page 2 — Key Business Insights

Five consulting-style insight cards with data-backed observations and specific recommendations:

**1. Electronics Concentration Risk**
Electronics drives 88% of revenue (₹3.35L of ₹3.8L). Recommend allocating 15–20% of marketing budget to Clothing and Home & Kitchen to bring electronics share below 70% within 2 quarters.

**2. Revenue Seasonality Alert**
January alone contributed ₹1.95L — 51% of the 6-month total. Remaining months averaged ₹37K. Recommend launching mid-year campaigns in April and June targeting a ₹60–80K monthly revenue floor.

**3. Digital Payment Dominance**
UPI (46%) + Credit Card (42%) = 88% of all payment value. Recommend negotiating preferential merchant rates with UPI providers and exploring BNPL options for orders above ₹30,000.

**4. Pan-India Geographic Spread**
Orders span 10 cities organically. Jaipur, Kochi and Lucknow show latent Tier-2 demand. Recommend geo-targeted campaigns with ₹5,000/month test budget per city for one quarter.

**5. Operational Excellence**
100% on-time delivery rate, 4.4/5 average customer rating, 8.3% cancellation rate. Recommend formalising logistics SLA dashboards before scaling beyond 50 orders/month.

---

## Key Findings

| Metric | Value |
|---|---|
| Total Revenue (Jan–Jun 2024) | ₹3,80,281 |
| Total Orders | 12 |
| Avg Order Value | ₹38,028 |
| Top Category | Electronics (88% of revenue) |
| Top Product | Apple MacBook Air M2 (₹2,29,998) |
| Top Payment Mode | UPI (46%) |
| On-Time Delivery Rate | 100% |
| Avg Customer Rating | 4.4 / 5 |
| Cities Covered | 10 (pan-India) |
| January Revenue Share | 51% of 6-month total |

---

## Tools & Technologies

| Tool | Purpose |
|---|---|
| MySQL | Database design, schema, FK relationships |
| Python (Pandas) | Data cleaning and transformation |
| Python (Plotly) | Interactive visualisations |
| Jupyter Notebook | Exploratory data analysis |
| Streamlit | Web dashboard deployment |
| Power BI Desktop | Business intelligence report |
| DAX | KPI measures including time intelligence |
| GitHub | Version control and portfolio showcase |

---

## How to Run

**Streamlit app:**
bash
pip install -r requirements.txt
streamlit run streamlit/app.py
link to streamlit https://elitestores-dashboard-do9r68bmsmd4ojhjhrkn6s.streamlit.app/

**Jupyter notebook:**
```bash
jupyter notebook eda/elitestores_eda.ipynb
```

**Power BI report:**  
Open `powerbi/Elitestores_Dashboard_BI.pbix` in Power BI Desktop (free download from microsoft.com/en-us/power-platform/products/power-bi/desktop)

**MySQL schema:**
```sql
source sql/schema.sql
```

---

## Author

**Rohit Godshelwar**  
Data Analytics · Power BI · Python · SQL  
[GitHub](https://github.com/godshelwarrohit)
