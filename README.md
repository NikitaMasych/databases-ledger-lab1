## Modern technologies of the Databases: Lab 1

### Subject

Web3 exchange system.

### Key features:

* 15 entities
* 5 triggers
* 5+2 functions

### Triggers

    User Update: A trigger to automatically set updated_at timestamp when row is updated.

    Balance Update: A trigger that updates user balances in the Wallets table after each transaction to reflect changes in assets.

    Security Log for Web3 Integrations: A trigger that adds security logs for web3 integrations activity.

    KYC/AML Compliance: A trigger to enforce KYC/AML compliance rules when users register or update their profiles.

    Transactions Validation: A trigger to check conformity of fields in transaction.

### Functions

    Calculate Transaction Fee: A function to calculate and return the transaction fee based on the transaction details and gas fees.

    User Identity Verification: A function to verify a user's identity for KYC/AML compliance.

### Dataset

Sample data is provided.