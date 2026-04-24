@IsTest
private class AccountServiceTest {
    @IsTest static void testCreateFindRename() {
        // Create
        Id accId = AccountService.createSimpleAccount('Test Co');
        System.assertNotEquals(null, accId, 'Account Id should not be null');

        // Set Industry to ensure query returns a result
        update new Account(Id = accId, Industry = 'Technology');

        // Find
        Test.startTest();
        List<Account> results = AccountService.findAccountsByIndustry('Technology');
        Test.stopTest();

        System.assert(results.size() > 0, 'Expected at least one account');
        System.assertEquals('Technology', results[0].Industry, 'Industry should match');

        // Rename
        AccountService.renameAccount(accId, 'Test Co Renamed');
        Account updated = [SELECT Name FROM Account WHERE Id = :accId];
        System.assertEquals('Test Co Renamed', updated.Name, 'Account name should be updated');
    }
}