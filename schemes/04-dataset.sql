-- Sample data for Users table
INSERT INTO users (wallet_address, username, contact_info)
VALUES
    ('user1_wallet', 'User 1', 'user1_contact@example.com'),
    ('user2_wallet', 'User 2', 'user2_contact@example.com');

-- Sample data for Assets table
INSERT INTO assets (asset_name, asset_symbol, description)
VALUES
    ('Bitcoin', 'BTC', 'Digital currency'),
    ('Ethereum', 'ETH', 'Blockchain platform'),
    ('Litecoin', 'LTC', 'Cryptocurrency');

-- Sample data for Order Book table
INSERT INTO order_book (user_id, asset_id, order_type, price, quantity, timestamp)
VALUES
    (1, 1, 'buy', 60000.00, 0.5, NOW()),
    (2, 2, 'sell', 3000.00, 1.2, NOW());

-- Sample data for Transactions table
INSERT INTO transactions (buyer_user_id, seller_user_id, asset_id, price, quantity, timestamp)
VALUES
    (1, 2, 1, 59000.00, 0.3, NOW()),
    (2, 1, 2, 2800.00, 0.6, NOW());

-- Sample data for Wallets table
INSERT INTO wallets (user_id, asset_id, balance)
VALUES
    (1, 1, 10000),
    (2, 2, 15000);

-- Sample data for Staking table
INSERT INTO staking (user_id, asset_id, amount, start_date)
VALUES
    (1, 1, 5.0, NOW() - INTERVAL '30 days'),
    (2, 2, 7.0, NOW() - INTERVAL '15 days');

-- Sample data for Rewards table
INSERT INTO rewards (user_id, asset_id, reward_amount, reward_date)
VALUES
    (1, 1, 2.0, NOW() - INTERVAL '5 days'),
    (2, 2, 3.0, NOW() - INTERVAL '3 days');

-- Sample data for Smart Contracts table
INSERT INTO smart_contracts (contract_name, contract_address, description)
VALUES
    ('Contract 1', '0xContract1', 'Sample contract 1'),
    ('Contract 2', '0xContract2', 'Sample contract 2');

-- Sample data for Gas Fees table
INSERT INTO gas_fees (user_id, transaction_id, fee_amount, fee_date)
VALUES
    (1, 1, 0.01, NOW() - INTERVAL '1 hour'),
    (2, 2, 0.02, NOW() - INTERVAL '2 hours');

-- Sample data for KYC/AML Compliance table
INSERT INTO kyc_aml (user_id, kyc_status, aml_status)
VALUES
    (1, 'approved', 'cleared'),
    (2, 'pending', 'suspicious');

-- Sample data for Security Logs table
INSERT INTO security_logs (user_id, log_text, log_timestamp)
VALUES
    (1, 'User login', NOW() - INTERVAL '1 hour'),
    (2, 'Password change', NOW() - INTERVAL '2 hours');

-- Sample data for Decentralized Identity table
INSERT INTO decentralized_identity (user_id, identity_info)
VALUES
    (1, '{"name": "User 1", "identity_document": "Passport"}'),
    (2, '{"name": "User 2", "identity_document": "Drivers License"}');

-- Sample data for Blockchain Transactions table
INSERT INTO blockchain_transactions (user_id, asset_id, transaction_type, transaction_hash, timestamp)
VALUES
    (1, 1, 'send', '0xTransactionHash1', NOW() - INTERVAL '5 minutes'),
    (2, 2, 'receive', '0xTransactionHash2', NOW() - INTERVAL '10 minutes');

-- Sample data for Web3 Integration table
INSERT INTO web3_integrations (user_id, web3_info)
VALUES
    (1, '{"provider": "Web3 Provider 1", "api_key": "API_KEY_1"}'),
    (2, '{"provider": "Web3 Provider 2", "api_key": "API_KEY_2"}');
