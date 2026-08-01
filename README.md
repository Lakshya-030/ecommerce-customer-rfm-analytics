# Ecommerce Customer RFM Analytics

## Project Overview

This project performs RFM (Recency, Frequency, Monetary) Analysis on an e-commerce retail dataset to segment customers based on their purchasing behavior. The insights help businesses identify valuable customers, improve retention strategies, and design targeted marketing campaigns.

---

## Business Problem

Not all customers contribute equally to revenue. Businesses need to identify:

- High-value customers
- Loyal customers
- Customers at risk of churning
- Inactive customers

This helps optimize marketing efforts and improve customer retention.

---

## Tech Stack

- SQL (MySQL)
- Power BI
- Excel

---

## RFM Metrics

- **Recency:** Days since the customer's last purchase.
- **Frequency:** Number of unique orders placed.
- **Monetary:** Total amount spent by the customer.

Customers were scored using the `NTILE()` window function and then segmented into business-oriented customer groups.

---

## Customer Segments

- Champions
- Loyal Customers
- Potential Loyalists
- Can't Lose Them
- Need Attention
- Hibernating / Lost

---

## Dashboard Highlights

- Customer Segment Distribution
- Revenue by Customer Segment
- Average Recency, Frequency & Monetary Analysis
- Customer Scatter Plot Analysis
- Retention Cohort Analysis

---

## Key Business Insights

- Champions generated the highest revenue.
- Hibernating / Lost customers contributed the least revenue.
- High-value inactive customers were identified for targeted retention campaigns.
- Customer segmentation enables personalized marketing and retention strategies.

---

## Project Files

- `online_retail.sql` – SQL scripts used for RFM analysis
- `rfm_analysis.pbix` – Interactive Power BI dashboard
- `online_retail_II.csv.zip` – Dataset

---

## Skills Demonstrated

- SQL Window Functions
- Customer Segmentation
- Data Cleaning
- Business Analytics
- Power BI Dashboarding
- Cohort Analysis
