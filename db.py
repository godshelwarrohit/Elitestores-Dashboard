import pandas as pd
import os

# ── Load all CSV files once ─────────────────────────────────────────────────
BASE = os.path.dirname(__file__)

customers   = pd.read_csv(os.path.join(BASE, "customers.csv"))
products    = pd.read_csv(os.path.join(BASE, "products.csv"))
orders      = pd.read_csv(os.path.join(BASE, "orders.csv"))
order_items = pd.read_csv(os.path.join(BASE, "order_items.csv"))
payments    = pd.read_csv(os.path.join(BASE, "payments.csv"))
categories  = pd.read_csv(os.path.join(BASE, "categories.csv"))
reviews     = pd.read_csv(os.path.join(BASE, "reviews.csv"))
shipping    = pd.read_csv(os.path.join(BASE, "shipping.csv"))