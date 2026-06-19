public with sharing class NovaTechAccountHealthController {
    
    @AuraEnabled(cacheable=true)
    public static AccountHealthWrapper getAccountHealth(Id accountId) {
        Account acc = [
            SELECT Id, Name, Industry, Rating
            FROM Account
            WHERE Id = :accountId
            LIMIT 1
        ];

        Integer oppCount = [
            SELECT COUNT()
            FROM Opportunity
            WHERE AccountId = :accountId
        ];

        Integer quoteCount = [
            SELECT COUNT()
            FROM SBQQ__Quote__c
            WHERE SBQQ__Account__c = :accountId
        ];

        String status = 'Needs opportunity activity';

        if (quoteCount > 0) {
            status = 'Quote activity detected';
        } else if (oppCount > 0) {
            status = 'Active sales motion';
        }

        return new AccountHealthWrapper(
            acc.Name,
            acc.Industry,
            acc.Rating,
            oppCount,
            quoteCount,
            status
        );
    }

    public class AccountHealthWrapper {
        @AuraEnabled public String accountName;
        @AuraEnabled public String industry;
        @AuraEnabled public String rating;
        @AuraEnabled public Integer opportunityCount;
        @AuraEnabled public Integer quoteCount;
        @AuraEnabled public String status;

        public AccountHealthWrapper(
            String accountName,
            String industry,
            String rating,
            Integer opportunityCount,
            Integer quoteCount,
            String status
        ) {
            this.accountName = accountName;
            this.industry = industry;
            this.rating = rating;
            this.opportunityCount = opportunityCount;
            this.quoteCount = quoteCount;
            this.status = status;
        }
    }
}