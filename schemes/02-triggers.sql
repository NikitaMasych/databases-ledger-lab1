-- Create a BEFORE INSERT OR UPDATE trigger on the Users table
CREATE OR REPLACE FUNCTION enforce_kyc_aml_compliance() RETURNS TRIGGER AS $$
DECLARE
    user_kyc_record RECORD;
BEGIN
    -- Retrieve the KYC/AML record for the user
    SELECT * INTO user_kyc_record
    FROM kyc_aml
    WHERE user_id = NEW.user_id;

    -- Check KYC and AML compliance
    IF user_kyc_record.kyc_status IS NULL OR user_kyc_record.aml_status IS NULL THEN
        RAISE EXCEPTION 'KYC and AML compliance statuses are required for user profile update.';
    END IF;

    -- Enforce KYC/AML rules:
    -- If KYC status is 'pending', disallow profile update.
    IF user_kyc_record.kyc_status = 'pending' THEN
        RAISE EXCEPTION 'KYC verification is pending. Profile update is not allowed.';
    END IF;

    -- AML check: Prevent registration if AML status is 'suspicious.'
    IF user_kyc_record.aml_status = 'suspicious' THEN
        RAISE EXCEPTION 'AML status is suspicious. Profile update is not allowed.';
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

----------------------------------------------------------------------------------------------------

-- Create an AFTER INSERT OR DELETE trigger on the Wallets table to update liquidity pool size
CREATE OR REPLACE FUNCTION update_liquidity_pool_size()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if a record exists in the liquidity pool for the asset
    IF TG_OP = 'INSERT' THEN
        -- Increase the liquidity pool size when a new liquidity provider adds tokens.
        UPDATE liquidity_pools
        SET pool_size = COALESCE(pool_size, 0) + NEW.balance
        WHERE asset_id = NEW.asset_id;
        
        -- If there is no existing record for the asset, insert a new record.
        IF NOT FOUND THEN
            INSERT INTO liquidity_pools (asset_id, pool_size)
            VALUES (NEW.asset_id, NEW.balance);
        END IF;
    ELSIF TG_OP = 'DELETE' THEN
        -- Decrease the liquidity pool size when a liquidity provider removes tokens.
        UPDATE liquidity_pools
        SET pool_size = COALESCE(pool_size, 0) - OLD.balance
        WHERE asset_id = OLD.asset_id;
        
        -- If there is no existing record for the asset, insert a new record.
        IF NOT FOUND THEN
            INSERT INTO liquidity_pools (asset_id, pool_size)
            VALUES (OLD.asset_id, -OLD.balance);
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Attach the trigger to the Wallets table for INSERT and DELETE operations
CREATE TRIGGER after_insert_or_delete_update_liquidity_pool_size
AFTER INSERT OR DELETE ON wallets
FOR EACH ROW
EXECUTE FUNCTION update_liquidity_pool_size();