-- Create a BEFORE INSERT OR UPDATE trigger on the Users table
CREATE OR REPLACE FUNCTION enforce_kyc_aml_compliance() RETURNS TRIGGER AS $$
BEGIN
    -- Check KYC and AML compliance for new user registration or profile update
    IF NEW.kyc_status IS NULL OR NEW.aml_status IS NULL THEN
        RAISE EXCEPTION 'KYC and AML compliance statuses are required for user registration or profile update.';
    END IF;

    -- Enforce KYC/AML rules:
    -- If KYC status is 'pending', disallow registration or profile update.
    IF NEW.kyc_status = 'pending' THEN
        RAISE EXCEPTION 'KYC verification is pending. Registration or profile update is not allowed.';
    END IF;

    -- AML check: Prevent registration if AML status is 'suspicious.'
    IF NEW.aml_status = 'suspicious' THEN
        RAISE EXCEPTION 'AML status is suspicious. Registration or profile update is not allowed.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Attach the trigger to the Users table for UPDATE operations
CREATE TRIGGER enforce_kyc_aml_compliance_trigger
BEFORE UPDATE ON Users
FOR EACH ROW
EXECUTE FUNCTION enforce_kyc_aml_compliance();

----------------------------------------------------------------------------------------------------

-- Create an AFTER INSERT trigger on the Transactions table
CREATE OR REPLACE FUNCTION update_wallet_balance_trigger() RETURNS TRIGGER AS $$
BEGIN
    -- Update the buyer's and seller's wallet balances based on the transaction

    -- Update the buyer's balance by subtracting the purchased asset.
    UPDATE wallets
    SET balance = balance - (NEW.price * NEW.quantity)
    WHERE user_id = NEW.buyer_user_id AND asset_id = NEW.asset_id;

    -- Update the seller's balance by adding the sold asset.
    UPDATE wallets
    SET balance = balance + NEW.quantity
    WHERE user_id = NEW.seller_user_id AND asset_id = NEW.asset_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Attach the trigger to the Transactions table
CREATE TRIGGER after_insert_update_wallet_balance
AFTER INSERT ON transactions
FOR EACH ROW
EXECUTE FUNCTION update_wallet_balance_trigger();

----------------------------------------------------------------------------------------------------

-- Create a trigger function that updates the updated_at field
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger to execute the function on UPDATE
CREATE TRIGGER users_updated_at_trigger
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

----------------------------------------------------------------------------------------------------

-- Create a trigger function to log changes to the security_logs table for the web3_integrations table
CREATE OR REPLACE FUNCTION log_web3_integration_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO security_logs (user_id, log_text, log_timestamp)
        VALUES (NEW.user_id, 'Web3 Integration added', NOW());
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO security_logs (user_id, log_text, log_timestamp)
        VALUES (NEW.user_id, 'Web3 Integration updated', NOW());
    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO security_logs (user_id, log_text, log_timestamp)
        VALUES (OLD.user_id, 'Web3 Integration deleted', NOW());
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger to execute the log_web3_integration_changes function on INSERT, UPDATE, or DELETE for the web3_integrations table
CREATE TRIGGER web3_integrations_security_logs_trigger
AFTER INSERT OR UPDATE OR DELETE ON web3_integrations
FOR EACH ROW
EXECUTE FUNCTION log_web3_integration_changes();

----------------------------------------------------------------------------------------------------

-- Create a trigger function to validate transactions
CREATE OR REPLACE FUNCTION validate_transaction()
RETURNS TRIGGER AS $$
BEGIN
    
    -- Ensure the price and quantity are non-negative.
    IF NEW.price < 0 OR NEW.quantity < 0 THEN
        RAISE EXCEPTION 'Price and quantity must be non-negative.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger to execute the validate_transaction function on INSERT or UPDATE
CREATE TRIGGER transactions_validation_trigger
BEFORE INSERT OR UPDATE ON transactions
FOR EACH ROW
EXECUTE FUNCTION validate_transaction();
