import streamlit as st
import pandas as pd
import plotly.express as px
import warnings
warnings.filterwarnings('ignore')
from db import (customers, products, orders, order_items,
                payments, categories, reviews, shipping)

#
st.set_page_config(
    page_title="EliteStores Dashboard",
    page_icon="🛒",
    layout="wide"
)

# ── Merge helper dataframes 
orders_items = order_items.merge(orders, on="order_id")
orders_items = orders_items[orders_items["order_status"] != "cancelled"]
orders_items_prod = orders_items.merge(products, on="product_id")
orders_items_cat  = orders_items_prod.merge(categories, on="category_id")

#
st.title(" EliteStores — Sales Analytics Dashboard")
st.markdown("Real-time insights from the EliteStores e-commerce database.")
st.divider()


# SECTION 1: KPI CARDS


total_revenue  = round((orders_items["quantity"] * orders_items["unit_price"]).sum(), 2)
total_orders   = orders[orders["order_status"] != "cancelled"]["order_id"].nunique()
total_customers = len(customers)
aov            = round(total_revenue / total_orders, 2)

col1, col2, col3, col4 = st.columns(4)
col1.metric("💰 Total Revenue",   f"₹{total_revenue:,.0f}")
col2.metric("📦 Total Orders",    f"{total_orders}")
col3.metric("👥 Total Customers", f"{total_customers}")
col4.metric("🧾 Avg Order Value", f"₹{aov:,.0f}")

st.divider()


# SECTION 2: MONTHLY REVENUE TREND


st.subheader("📈 Monthly Revenue Trend")

orders_items["order_date"] = pd.to_datetime(orders_items["order_date"])
orders_items["month"] = orders_items["order_date"].dt.to_period("M").astype(str)

monthly = (orders_items.assign(revenue=orders_items["quantity"] * orders_items["unit_price"])
           .groupby("month")["revenue"].sum().reset_index()
           .sort_values("month"))

fig_trend = px.line(monthly, x="month", y="revenue", markers=True,
                    labels={"month": "Month", "revenue": "Revenue (₹)"},
                    color_discrete_sequence=["#636EFA"])
fig_trend.update_layout(hovermode="x unified")
st.plotly_chart(fig_trend, use_container_width=True)
st.divider()


# SECTION 3: TOP PRODUCTS + CATEGORY REVENUE


col_left, col_right = st.columns(2)

with col_left:
    st.subheader("🏆 Top 5 Products by Revenue")
    top_products = (orders_items_prod
                    .assign(revenue=orders_items_prod["quantity"] * orders_items_prod["unit_price"])
                    .groupby("product_name")["revenue"].sum()
                    .sort_values(ascending=False).head(5).reset_index())
    fig_prod = px.bar(top_products, x="revenue", y="product_name",
                      orientation="h", color="revenue",
                      color_continuous_scale="Blues",
                      labels={"revenue": "Revenue (₹)", "product_name": "Product"})
    fig_prod.update_layout(yaxis=dict(autorange="reversed"), coloraxis_showscale=False)
    st.plotly_chart(fig_prod, use_container_width=True)

with col_right:
    st.subheader("🗂️ Revenue by Category")
    cat_rev = (orders_items_cat
               .assign(revenue=orders_items_cat["quantity"] * orders_items_cat["unit_price"])
               .groupby("category_name")["revenue"].sum().reset_index())
    fig_cat = px.pie(cat_rev, names="category_name", values="revenue",
                     color_discrete_sequence=px.colors.qualitative.Pastel, hole=0.4)
    fig_cat.update_traces(textposition="inside", textinfo="percent+label")
    st.plotly_chart(fig_cat, use_container_width=True)

st.divider()


# SECTION 4: TOP CUSTOMERS + PAYMENT MODES


col_left2, col_right2 = st.columns(2)

with col_left2:
    st.subheader("👑 Top 5 Customers by Spend")
    cust_spend = (orders_items
                  .assign(revenue=orders_items["quantity"] * orders_items["unit_price"])
                  .groupby("customer_id")["revenue"].sum()
                  .reset_index()
                  .merge(customers[["customer_id", "first_name", "last_name"]], on="customer_id"))
    cust_spend["customer"] = cust_spend["first_name"] + " " + cust_spend["last_name"]
    cust_spend = cust_spend.sort_values("revenue", ascending=False).head(5)
    fig_cust = px.bar(cust_spend, x="customer", y="revenue",
                      color="revenue", color_continuous_scale="Greens",
                      labels={"customer": "Customer", "revenue": "Total Spent (₹)"})
    fig_cust.update_layout(coloraxis_showscale=False)
    st.plotly_chart(fig_cust, use_container_width=True)

with col_right2:
    st.subheader("💳 Payment Mode Breakdown")
    pay_modes = (payments[payments["payment_status"] == "completed"]
                 ["payment_mode"].value_counts().reset_index())
    pay_modes.columns = ["payment_mode", "transactions"]
    fig_pay = px.bar(pay_modes, x="payment_mode", y="transactions",
                     color="transactions", color_continuous_scale="Oranges",
                     labels={"payment_mode": "Payment Mode", "transactions": "Transactions"})
    fig_pay.update_layout(coloraxis_showscale=False)
    st.plotly_chart(fig_pay, use_container_width=True)

st.divider()


# SECTION 5: ORDER STATUS + LOW STOCK


col_left3, col_right3 = st.columns(2)

with col_left3:
    st.subheader("📊 Order Status Breakdown")
    status = orders["order_status"].value_counts().reset_index()
    status.columns = ["order_status", "total"]
    fig_status = px.pie(status, names="order_status", values="total",
                        color_discrete_sequence=px.colors.qualitative.Set2, hole=0.4)
    fig_status.update_traces(textposition="inside", textinfo="percent+label")
    st.plotly_chart(fig_status, use_container_width=True)

with col_right3:
    st.subheader("⚠️ Low Stock Alert (< 100 units)")
    low_stock = (products[products["stock"] < 100]
                 .merge(categories, on="category_id")
                 [["product_name", "category_name", "stock", "price"]]
                 .sort_values("stock"))
    low_stock.columns = ["Product", "Category", "Units Left", "Price (₹)"]
    st.dataframe(low_stock.style.background_gradient(subset=["Units Left"], cmap="Reds_r"),
                 use_container_width=True, hide_index=True)

st.divider()


# SECTION 6: PRODUCT RATINGS


st.subheader("⭐ Product Ratings Leaderboard")

ratings = (reviews.groupby("product_id")
           .agg(avg_rating=("rating", "mean"), total_reviews=("review_id", "count"))
           .reset_index()
           .merge(products[["product_id", "product_name"]], on="product_id"))
ratings["avg_rating"] = ratings["avg_rating"].round(1)
ratings = ratings.sort_values("avg_rating", ascending=False)

fig_rat = px.bar(ratings, x="product_name", y="avg_rating",
                 color="avg_rating", color_continuous_scale="RdYlGn",
                 range_color=[1, 5], text="avg_rating",
                 labels={"product_name": "Product", "avg_rating": "Avg Rating"})
fig_rat.update_traces(textposition="outside")
fig_rat.update_layout(coloraxis_showscale=False, yaxis_range=[0, 5.5])
st.plotly_chart(fig_rat, use_container_width=True)

st.divider()
st.caption("Built with Streamlit · Pandas · Plotly | EliteStores Analytics Dashboard")