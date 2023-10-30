-- Create the Users table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    wallet_address VARCHAR(255) NOT NULL,
    username VARCHAR(100),
    contact_info VARCHAR(255),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Create the Assets table
CREATE TABLE assets (
    asset_id SERIAL PRIMARY KEY,
    asset_name VARCHAR(50) NOT NULL,
    asset_symbol VARCHAR(10) NOT NULL,
    description TEXT
);

-- Create the Order Book table
CREATE TABLE order_book (
    order_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    asset_id INT REFERENCES assets(asset_id),
    order_type VARCHAR(10) NOT NULL, -- 'buy' or 'sell'
    price DECIMAL(18, 8) NOT NULL,
    quantity DECIMAL(18, 8) NOT NULL,
    timestamp TIMESTAMP
);

-- Create the Transactions table
CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    buyer_user_id INT REFERENCES users(user_id),
    seller_user_id INT REFERENCES users(user_id),
    asset_id INT REFERENCES assets(asset_id),
    price DECIMAL(18, 8) NOT NULL,
    quantity DECIMAL(18, 8) NOT NULL,
    timestamp TIMESTAMP
);

-- Create the Wallets table
CREATE TABLE wallets (
    wallet_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    asset_id INT REFERENCES assets(asset_id),
    balance DECIMAL(18, 8) NOT NULL
);

-- Create the Liquidity Pools table
CREATE TABLE liquidity_pools (
    pool_id SERIAL PRIMARY KEY,
    asset_id INT REFERENCES assets(asset_id),
    pool_size DECIMAL(18, 8) NOT NULL
);

-- Create the Staking table
CREATE TABLE staking (
    staking_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    asset_id INT REFERENCES assets(asset_id),
    amount DECIMAL(18, 8) NOT NULL,
    start_date TIMESTAMP
);

-- Create the Rewards table
CREATE TABLE rewards (
    reward_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    asset_id INT REFERENCES assets(asset_id),
    reward_amount DECIMAL(18, 8) NOT NULL,
    reward_date TIMESTAMP
);

-- Create the Smart Contracts table
CREATE TABLE smart_contracts (
    contract_id SERIAL PRIMARY KEY,
    contract_name VARCHAR(100) NOT NULL,
    contract_address VARCHAR(255) NOT NULL,
    description TEXT
);

-- Create the Gas Fees table
CREATE TABLE gas_fees (
    fee_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    transaction_id INT,
    fee_amount DECIMAL(18, 8) NOT NULL,
    fee_date TIMESTAMP
);

-- Create the KYC/AML Compliance table
CREATE TABLE kyc_aml (
    kycaml_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    kyc_status VARCHAR(20) NOT NULL, -- 'approved', 'pending', 'rejected'
    aml_status VARCHAR(20) NOT NULL -- 'cleared', 'suspicious'
);

-- Create the Security Logs table
CREATE TABLE security_logs (
    log_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    log_text TEXT,
    log_timestamp TIMESTAMP
);

-- Create the Decentralized Identity table
CREATE TABLE decentralized_identity (
    identity_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    identity_info JSONB
);

-- Create the Blockchain Transactions table
CREATE TABLE blockchain_transactions (
    tx_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    asset_id INT REFERENCES assets(asset_id),
    transaction_type VARCHAR(10) NOT NULL, -- 'send', 'receive', 'swap'
    transaction_hash VARCHAR(255) NOT NULL,
    timestamp TIMESTAMP
);

-- Create the Web3 Integration table
CREATE TABLE web3_integrations (
    integration_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    web3_info JSONB
);