-- Create a function to verify a user's identity for KYC/AML compliance
CREATE OR REPLACE FUNCTION verify_user_identity(
    userID INT,
    verification_result VARCHAR(20) -- 'approved' or 'rejected'
)
RETURNS VOID AS $$
BEGIN
    IF verification_result = 'approved' THEN
        -- Update the user's KYC status to 'approved'.
        UPDATE kyc_aml
        SET kyc_status = 'approved'
        WHERE kyc_aml.user_id = userID;
    ELSIF verification_result = 'rejected' THEN
        -- Update the user's KYC status to 'rejected'.
        UPDATE kyc_aml
        SET kyc_status = 'rejected'
        WHERE kyc_aml.user_id = userID;
    END IF;
     
END;
$$ LANGUAGE plpgsql;

----------------------------------------------------------------------------------------------------

-- Create a function to calculate the total transaction volume for a user in the last 24 hours
CREATE OR REPLACE FUNCTION calculate_total_transaction_volume(
    user_id INT
)
RETURNS DECIMAL(18, 8) AS $$
DECLARE
    total_volume DECIMAL(18, 8) := 0.0;
BEGIN
    -- Calculate the total transaction volume for a user in the last 24 hours.
    SELECT COALESCE(SUM(price * quantity), 0) INTO total_volume
    FROM transactions
    WHERE buyer_user_id = user_id
    AND timestamp >= NOW() - INTERVAL '24 hours';

    -- Return the total transaction volume.
    RETURN total_volume;
END;
$$ LANGUAGE plpgsql;

