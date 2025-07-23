-- Summary counts of flagged suspicious transactions by type

-- Flag 1: high amount ratio transactions summary
SELECT 
  COUNT(*) AS total_rows,
  SUM(is_high_amount_ratio) AS flagged_high_amount_ratio
FROM transactions;



-- Flag 2: night transactions summary
SELECT 
  COUNT(*) AS total_rows,
  SUM(is_night_transaction) AS flagged_night_transactions
FROM transactions;



-- FLag 3: quick repeated transactions
SELECT 
  COUNT(*) AS total_rows,
  SUM(is_fast_repeat_txn) AS flagged_fast_repeat
FROM transactions;



-- Flag 4: too many login attempts
SELECT 
  COUNT(*) AS total_rows,
  SUM(is_many_login_attempts) AS flagged_login_attempts
FROM transactions;



-- FLag 5: long transactions duration
SELECT 
  COUNT(*) AS total_rows,
  SUM(is_long_transaction_duration) AS flagged_duration_anomalies
FROM transactions;


-- Flag 6: new device or IP address
SELECT 
  COUNT(*) AS total_rows,
  SUM(is_new_device_or_ip) AS flagged_new_device_or_ip
FROM transactions;



-- Flag 7: location mismatch or not
SELECT 
  COUNT(*) AS total_rows,
  SUM(is_location_mismatch) AS flagged_location_mismatch
FROM transactions;



-- Flag 8: odd merchant frequency
SELECT 
  COUNT(*) AS total_rows,
  SUM(is_odd_merchant_frequency) AS flagged_odd_merchant_freq
FROM transactions;



-- Flag 9: huge balance drop
SELECT 
  COUNT(*) AS total_rows,
  SUM(is_large_balance_drop) AS flagged_large_balance_drop
FROM transactions;


-- Flag 10: channel switch
SELECT 
  COUNT(*) AS total_rows,
  SUM(is_channel_switch) AS flagged_channel_switch
FROM transactions;