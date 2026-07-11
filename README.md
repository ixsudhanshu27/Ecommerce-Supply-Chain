# Ecommerce-Supply-Chain
Using SQL (MySQL) to analyze 100k+ e-commerce transactions, identifying last-mile delivery bottlenecks and optimizing warehouse inventory tiers via ABC analysis.
# Data-Driven Supply Chain Optimization: Last-Mile & Inventory Analytics

## 📌 Project Overview
This project applies relational database analytics to a real-world dataset of 100k+ e-commerce orders. The objective is to evaluate operational efficiency across two core areas of supply chain management:
1. **Logistics & Last-Mile Performance:** Tracking delivery lead times and mapping regional carrier bottlenecks.
2. **Inventory Optimization:** Categorizing product segments using an ABC Costing Framework based on the Pareto Principle to streamline demand forecasting.

## 🛠️ Tech Stack & Tools
* **Database Engine:** MySQL
* **Concepts:** Common Table Expressions (CTEs), Window Functions, Data Aggregation, Date-Time Manipulation

## 📊 Key Business Insights & Operations Impact

### 1. Last-Mile Latency Mapping (Logistics)
* **The Insight:** By calculating the variance between estimated and actual delivery dates (`DATEDIFF`), the analysis isolated specific states (e.g., Alagoas and Acre) experiencing average delays of over 4 days beyond consumer expectations.
* **Operational Recommendation:** Transition from a single national carrier to a hub-and-spoke model, routing high-velocity items to regional fulfillment centers near bottleneck zones.

### 2. ABC Inventory Classification (Demand Analysis)
* **The Insight:** Built a cumulative revenue tracking model using SQL window functions (`SUM() OVER`). The data revealed a classic Pareto distribution: **18% of product categories generate over 80% of total revenue (Class A items).**
* **Operational Recommendation:** Class A items should migrate to a Continuous Review Inventory System with automated safety stock triggers to eliminate stockouts on high-margin goods.

2. Set up your local database schema using the instructions in `data_source.txt`.
3. Execute `/scripts/01_logistics_performance.sql` for delivery cycle analysis.
4. Execute `/scripts/02_abc_inventory_analysis.sql` for inventory stratification.
