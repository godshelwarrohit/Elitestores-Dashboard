# EliteStores Sales Analytics Dashboard

An interactive sales analytics dashboard for an e-commerce platform built with Streamlit, Python, and Plotly. Visualizes real business KPIs including revenue trends, product performance, customer analytics, and inventory alerts.

## Live Demo

[View Live Dashboard](https://elitestores-dashboard-do9r68bmsmd4ojhjhrkn6s.streamlit.app)
<img width="1902" height="909" alt="image" src="https://github.com/user-attachments/assets/90fdfb76-2b8e-499f-8f1e-f9235dc43efc" />

## Dashboard Sections

| Section | Description |
|---------|-------------|
| KPI Cards | Total Revenue, Orders, Customers, Avg Order Value |
| Monthly Revenue Trend | Line chart of revenue performance over time |
| Top 5 Products | Best-selling products ranked by revenue |
| Revenue by Category | Revenue contribution split by product category |
| Top Customers | Highest spending customers |
| Payment Mode Breakdown | Most popular payment methods by transaction count |
| Order Status Distribution | Breakdown of delivered, pending and cancelled orders |
| Low Stock Alert | Products with fewer than 100 units remaining |
| Product Ratings Leaderboard | Average ratings with total review counts |

## Tech Stack

![Python]
![Streamlit]
![Pandas]
![Plotly]
![MySQL]

## Data Source

The data was originally designed as a fully normalized MySQL relational database with 9 tables following Third Normal Form (3NF). Key design decisions include:

- unit_price stored in order_items to preserve historical pricing accuracy
- ENUM constraints on all status fields to enforce data integrity
- UNIQUE constraint on reviews to prevent duplicate submissions
- Timestamps on all core tables for auditability

The complete MySQL schema with all constraints, foreign keys, and 7 analytical queries is available in E-commerce table design.sql.


## Run Locally

### Prerequisites
- Python 3.10 or above
- pip

### Setup

bash
Clone the repository
git clone https://github.com/godshelwarrohit/Elitestores-Dashboard.git
cd Elitestores-Dashboard

Install dependencies
pip install -r requirements.txt

 Run the dashboard
streamlit run app.py

The dashboard will open at http://localhost:8501

## Requirements

streamlit
pandas
plotly
matplotlib

## Key Business Insights

- Electronics category contributes the highest share of total revenue
- UPI is the most preferred payment mode among customers
- Three products are critically low on stock and require immediate restocking
- Top two customers account for a disproportionate share of total spend
- Average order value of Rs 45,025 indicates a premium product mix

## Author
Rohit Godshelwar

## License

This project is open source and available under the [MIT License](LICENSE).
