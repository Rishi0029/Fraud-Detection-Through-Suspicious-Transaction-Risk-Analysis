-- Add new column to store risk score
ALTER TABLE transactions
ADD COLUMN FraudRiskScore INT;

-- analyze risk score by summing the 10 risk flags
UPDATE transactions
SET FraudRiskScore =
    IFNULL(is_high_amount_ratio,0) +
    IFNULL(is_night_transaction,0) +
    IFNULL(is_fast_repeat_txn,0) +
    IFNULL(is_many_login_attempts,0) +
    IFNULL(is_long_transaction_duration,0) +
    IFNULL(is_new_device_or_ip,0) +
    IFNULL(is_location_mismatch,0) +
    IFNULL(is_odd_merchant_frequency,0) +
    IFNULL(is_large_balance_drop,0) +
    IFNULL(is_channel_switch,0);


-- column to classify risk level
ALTER TABLE transactions
ADD COLUMN RiskLevel VARCHAR(10);

UPDATE transactions
SET RiskLevel = CASE
    WHEN FraudRiskScore <= 3 THEN 'Low'
    WHEN FraudRiskScore <= 6 THEN 'Medium'
    ELSE 'High'
END;


-- summarize results like count, average score and total transac. amount
SELECT 
  RiskLevel,
  COUNT(*) AS transaction_count,
  ROUND(AVG(FraudRiskScore),2) AS avg_score,
  SUM(TransactionAmount) AS total_amount
FROM transactions
GROUP BY RiskLevel
ORDER BY avg_score DESC;
