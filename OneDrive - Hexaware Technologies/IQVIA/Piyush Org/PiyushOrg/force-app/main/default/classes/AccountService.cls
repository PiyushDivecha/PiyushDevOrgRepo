public with sharing class AccountService {
    // Creates a basic Account and returns its Id
    public static Id createSimpleAccount(String name) {
        Account acc = new Account(Name = name);
        insert acc;
        return acc.Id;
    }

    // Finds up to 100 Accounts by Industry
    public static List<Account> findAccountsByIndustry(String industry) {
        return [
            SELECT Id, Name, Industry
            FROM Account
            WHERE Industry = :industry
            ORDER BY Name
            LIMIT 100
        ];
    }

    // Renames an existing Account by Id
    public static void renameAccount(Id accountId, String newName) {
        Account acc = new Account(Id = accountId, Name = newName);
        update acc;
    }
}