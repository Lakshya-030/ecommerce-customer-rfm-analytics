USE rfm_project;
DROP VIEW IF EXISTS v_final_rfm_analysis;
CREATE OR REPLACE VIEW v_final_rfm_analysis AS

WITH cte_rfm_raw AS (
SELECT CustomerID,
DATEDIFF((SELECT MAX(InvoiceDate) FROM online_retail), MAX(InvoiceDate)) AS raw_recency,
COUNT(DISTINCT Invoice) AS raw_frequency,
ROUND(SUM(Quantity * Price),2) AS raw_monetary
FROM online_retail
WHERE CustomerID IS NOT NULL
AND CustomerID <> ''
AND Quantity > 0
AND Price > 0
GROUP BY CustomerID
),

cte_rfm_scores AS (
SELECT CustomerID,
raw_recency,
raw_frequency,
raw_monetary,
6 - NTILE(5) OVER(ORDER BY raw_recency ASC) AS r_score,
6 - NTILE(5) OVER(ORDER BY raw_frequency DESC) AS f_score,
6 - NTILE(5) OVER(ORDER BY raw_monetary DESC) AS m_score
FROM cte_rfm_raw
)

SELECT CustomerID,
raw_recency,
raw_frequency,
raw_monetary,
r_score,
f_score,
m_score,
CONCAT_WS('-',r_score,f_score,m_score) AS rfm_cell,

CASE
WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
WHEN r_score >= 3 AND f_score >= 4 AND m_score >= 3 THEN 'Loyal Customers'
WHEN r_score >= 4 AND (f_score = 2 OR f_score = 3) THEN 'Potential Loyalists'
WHEN r_score <= 2 AND f_score >= 3 AND m_score >= 4 THEN 'Cant Lose Them'
WHEN r_score >= 4 AND f_score <= 2 THEN 'Promising Customers'
WHEN r_score <= 2 AND f_score <= 2 AND m_score <= 2 THEN 'Hibernating / Lost'
ELSE 'Need Attention'
END AS customer_segment

FROM cte_rfm_scores;

SELECT * FROM v_final_rfm_analysis;

SELECT customer_segment,
COUNT(CustomerID) AS total_customers,
ROUND(COUNT(CustomerID)*100.0/(SELECT COUNT(*) FROM v_final_rfm_analysis),2) AS percentage_of_total,
ROUND(AVG(raw_monetary),2) AS average_spend
FROM v_final_rfm_analysis
GROUP BY customer_segment
ORDER BY total_customers DESC;

WITH cte_purchase_gaps AS (
SELECT CustomerID,
Invoice,
InvoiceDate,
LAG(InvoiceDate) OVER(PARTITION BY CustomerID ORDER BY InvoiceDate) AS previous_invoice_date
FROM online_retail
WHERE CustomerID IS NOT NULL
AND CustomerID <> ''
AND Quantity > 0
AND Price > 0
GROUP BY CustomerID,Invoice,InvoiceDate
),

cte_days_between AS (
SELECT CustomerID,
Invoice,
InvoiceDate,
previous_invoice_date,
DATEDIFF(InvoiceDate,previous_invoice_date) AS days_since_last_order
FROM cte_purchase_gaps
WHERE previous_invoice_date IS NOT NULL
)

SELECT CASE
WHEN days_since_last_order <= 30 THEN 'Repeat Buyer within 30 Days'
WHEN days_since_last_order <= 90 THEN 'Repeat Buyer within 3 Months'
WHEN days_since_last_order <= 180 THEN 'Repeat Buyer within 6 Months'
ELSE 'Slow Return (Over 6 Months)'
END AS retention_cohort,
COUNT(*) AS total_transactions,
ROUND(AVG(days_since_last_order),1) AS avg_days_to_return
FROM cte_days_between
GROUP BY retention_cohort
ORDER BY avg_days_to_return;

SELECT * FROM v_final_rfm_analysis;

SELECT customer_segment, COUNT(*)
FROM v_final_rfm_analysis
GROUP BY customer_segment;

SELECT customer_segment,
COUNT(*) AS customers,
ROUND(AVG(raw_recency),1) AS avg_recency,
ROUND(AVG(raw_frequency),1) AS avg_frequency,
ROUND(AVG(raw_monetary),2) AS avg_monetary
FROM v_final_rfm_analysis
GROUP BY customer_segment;