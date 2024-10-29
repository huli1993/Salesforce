({
    init: function (cmp, event, helper) {

        var action = cmp.get('c.getAccountOpportunities');
        action.setParams({
            "accountId": cmp.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.opportunities", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);

        cmp.set('v.columns', [
            { label: 'Opportunity Name', fieldName: 'Name', type: 'text' },
            { label: 'Stage', fieldName: 'StageName', type: 'text' },
            { label: 'Amount', fieldName: 'Amount', type: 'currency' }
        ]);
    }
});