--- TEST enforce_kyc_aml_compliance_trigger

SELECT * FROM users;
SELECT * FROM kyc_aml;

UPDATE users SET username='new username' WHERE user_id=2;

--- TEST users_updated_at_trigger

SELECT * FROM

UPDATE users SET username='new username' WHERE user_id=1;

--- TEST web3_integrations_security_logs_trigger

SELECT * FROM security_logs;
SELECT * FROM web3_integrations;

INSERT INTO web3_integrations(user_id, web3_info) VALUES (2, '{}');

SELECT * FROM security_logs;

--- TEST transactions_validation_trigger

SELECT * FROM transactions;

UPDATE transactions SET price=-1 WHERE transaction_id=1;

--- TEST after_insert_or_delete_update_liquidity_pool_size

SELECT * FROM liquidity_pools;

INSERT INTO wallets (user_id, asset_id, balance) VALUES (1, 3, 5500);

SELECT * FROM liquidity_pools;

------------------------------------------------------------------------------

--- TEST verify_user_identity

SELECT * FROM users;
SELECT * FROM kyc_aml;

SELECT verify_user_identity(2, 'approved');

SELECT * FROM kyc_aml;


--- TEST calculate_total_transaction_volume

SELECT * FROM transactions;

SELECT calculate_total_transaction_volume(1);