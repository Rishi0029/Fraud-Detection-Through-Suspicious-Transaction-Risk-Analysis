--Adding transaction hour, day and weekend

ALTER TABLE transactions
ADD COLUMN TransactionHour INT,
ADD COLUMN TransactionDay INT,
ADD COLUMN Weekday INT;

UPDATE transactions
SET 
    TransactionHour = HOUR(TransactionDate),
    TransactionDay = DAY(TransactionDate),
    Weekday = WEEKDAY(TransactionDate);





-- Flag 1: high amount ratio transactions summary
ALTER TABLE transactions
ADD COLUMN is_high_amount_ratio TINYINT;

UPDATE transactions
SET is_high_amount_ratio = 
CASE 
WHEN TransactionAmount > 0.75 * AccountBalance THEN 1
ELSE 0
END;




-- Flag 2: night transactions summary
ALTER TABLE transactions
ADD COLUMN is_night_transaction TINYINT;

UPDATE transactions
SET is_night_transaction =
  CASE
    WHEN TransactionHour >= 0 AND TransactionHour < 4 THEN 1
    ELSE 0
  END;




-- Flag 3: quick repeated transactions
ALTER TABLE transactions
ADD COLUMN is_fast_repeat_txn TINYINT;


CREATE TEMPORARY TABLE txn_time_diff AS
SELECT 
    TransactionID,
    TIMESTAMPDIFF(SECOND, 
        LAG(TransactionDate) OVER (PARTITION BY AccountID ORDER BY TransactionDate),
        TransactionDate
    ) AS seconds_since_last
FROM transactions;

UPDATE transactions t
JOIN txn_time_diff td ON t.TransactionID = td.TransactionID
SET t.is_fast_repeat_txn = 
  CASE 
    WHEN td.seconds_since_last IS NOT NULL AND td.seconds_since_last < 60 THEN 1
    ELSE 0
  END;




-- Flag 4: too many login attempts
ALTER TABLE transactions
ADD COLUMN is_many_login_attempts TINYINT;



UPDATE transactions
SET is_many_login_attempts =
  CASE 
    WHEN LoginAttempts > 3 THEN 1
    ELSE 0
  END;




-- Flag 5: long transactions duration
ALTER TABLE transactions
ADD COLUMN is_long_transaction_duration TINYINT;


UPDATE transactions
SET is_long_transaction_duration =
  CASE 
    WHEN TransactionDuration > 300 OR TransactionDuration < 3 THEN 1
    ELSE 0
  END;




-- Flag 6: new device or IP address
ALTER TABLE transactions
ADD COLUMN is_new_device_or_ip TINYINT;

CREATE TEMPORARY TABLE prev_device_ip AS
SELECT 
  TransactionID,
  LAG(DeviceID) OVER (PARTITION BY AccountID ORDER BY TransactionDate) AS prev_device,
  LAG(IP_Address) OVER (PARTITION BY AccountID ORDER BY TransactionDate) AS prev_ip,
  DeviceID,
  IP_Address
FROM transactions;

UPDATE transactions t
JOIN prev_device_ip p ON t.TransactionID = p.TransactionID
SET t.is_new_device_or_ip = 
  CASE 
    WHEN p.prev_device IS NOT NULL 
         AND (p.prev_device != p.DeviceID OR p.prev_ip != p.IP_Address)
    THEN 1
    ELSE 0
  END;




-- Flag 7: location mismatch or not
ALTER TABLE transactions
ADD COLUMN is_location_mismatch TINYINT;

CREATE TEMPORARY TABLE prev_location AS
SELECT 
  TransactionID,
  LAG(Location) OVER (PARTITION BY AccountID ORDER BY TransactionDate) AS prev_location,
  Location
FROM transactions;

UPDATE transactions t
JOIN prev_location p ON t.TransactionID = p.TransactionID
SET t.is_location_mismatch = 
  CASE 
    WHEN p.prev_location IS NOT NULL AND p.prev_location != p.Location THEN 1
    ELSE 0
  END;




-- Flag 8: odd merchant frequency
ALTER TABLE transactions
ADD COLUMN is_odd_merchant_frequency TINYINT;

CREATE TEMPORARY TABLE merchant_counts AS
SELECT 
  TransactionID,
  AccountID,
  MerchantID,
  DATE(TransactionDate) AS txn_date,
  COUNT(*) OVER (PARTITION BY AccountID, MerchantID, DATE(TransactionDate)) AS txn_count_same_merchant
FROM transactions;

UPDATE transactions t
JOIN merchant_counts m ON t.TransactionID = m.TransactionID
SET t.is_odd_merchant_frequency =
  CASE 
    WHEN m.txn_count_same_merchant > 3 THEN 1
    ELSE 0
  END;




-- Flag 9: huge balance drop
ALTER TABLE transactions
ADD COLUMN is_large_balance_drop TINYINT;


CREATE TEMPORARY TABLE balance_diff AS
SELECT 
  TransactionID,
  AccountID,
  AccountBalance,
  LAG(AccountBalance) OVER (PARTITION BY AccountID ORDER BY TransactionDate) AS prev_balance
FROM transactions;


UPDATE transactions t
JOIN balance_diff b ON t.TransactionID = b.TransactionID
SET t.is_large_balance_drop =
  CASE 
    WHEN b.prev_balance IS NOT NULL AND b.prev_balance > 0 
         AND t.AccountBalance < 0.5 * b.prev_balance
    THEN 1
    ELSE 0
  END;




-- Flag 10: channel switch
ALTER TABLE transactions
ADD COLUMN is_channel_switch TINYINT;

CREATE TEMPORARY TABLE channel_switch AS
SELECT 
  TransactionID,
  AccountID,
  Channel,
  TransactionDate,
  LAG(Channel) OVER (PARTITION BY AccountID ORDER BY TransactionDate) AS prev_channel,
  LAG(TransactionDate) OVER (PARTITION BY AccountID ORDER BY TransactionDate) AS prev_txn_time
FROM transactions;

UPDATE transactions t
JOIN channel_switch cs ON t.TransactionID = cs.TransactionID
SET t.is_channel_switch = 
  CASE 
    WHEN cs.prev_txn_time IS NOT NULL 
         AND TIMESTAMPDIFF(MINUTE, cs.prev_txn_time, cs.TransactionDate) <= 10
         AND cs.prev_channel != cs.Channel
    THEN 1
    ELSE 0
  END;

