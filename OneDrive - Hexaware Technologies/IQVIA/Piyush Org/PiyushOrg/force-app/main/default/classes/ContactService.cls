public with sharing class ContactService {
    @AuraEnabled
    public static Id createContact(Contact contactInput) {
        if (contactInput == null) {
            throw new AuraHandledException('No contact data was provided.');
        }

        try {
            // Enforce FLS for create, then extract sanitized record
            SObjectAccessDecision decision = Security.stripInaccessible(
                AccessType.CREATABLE,
                new List<Contact>{ contactInput }
            );

            List<SObject> sanitizedSObjects = decision.getRecords();
            if (sanitizedSObjects.isEmpty()) {
                throw new AuraHandledException('You do not have permission to create this Contact.');
            }

            Contact safeContact = (Contact) sanitizedSObjects[0];

            // Perform DML
            insert safeContact;
            return safeContact.Id;

        } catch (DmlException e) {
            // Present a user-friendly DML message
            throw new AuraHandledException(e.getDmlMessage(0));

        } catch (Exception e) {
            // Generic fallback
            throw new AuraHandledException('Unexpected error while creating Contact. Please try again or contact support.');
        }
    }
}