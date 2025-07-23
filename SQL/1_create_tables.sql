CREATE TABLE transactions (
    TransactionID VARCHAR(20) PRIMARY KEY,
    AccountID VARCHAR(20),
    TransactionAmount DECIMAL(10,2),
    TransactionDate DATETIME,
    TransactionType VARCHAR(50),
    Location VARCHAR(100),
    DeviceID VARCHAR(100),
    IP_Address VARCHAR(100),
    MerchantID VARCHAR(100),
    Channel VARCHAR(50),
    CustomerAge INT,
    CustomerOccupation VARCHAR(100),
    TransactionDuration DECIMAL(10,2),
    LoginAttempts INT,
    AccountBalance DECIMAL(12,2),
    PreviousTransactionDate DATETIME
);

CREATE TABLE customer_info (
    AccountID VARCHAR(20) PRIMARY KEY,
    CustomerAge INT,
    CustomerOccupation VARCHAR(100)
);

CREATE TABLE device_info (
    AccountID VARCHAR(20) PRIMARY KEY,
    DeviceID VARCHAR(100),
    IP_Address VARCHAR(100),
    Channel VARCHAR(50)
);
