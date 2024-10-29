({
    doInit: function(component, event, helper) {
        var action = component.get("c.getTaskDetails");
        action.setParams({ taskLogId: component.get("v.recordId") });

        console.log("Record ID:", component.get("v.recordId"));

        
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log("Apex call state: " + state);  
            if (state === "SUCCESS") {
                var task = response.getReturnValue();
                console.log("Task returned from Apex: ", task);  
                if (task) {
                    component.set("v.task", task);
                } else {
                    console.error("No task data returned from Apex.");
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    console.error("Apex error: " + errors[0].message); 
                    component.set("v.error", errors[0].message);
                } else {
                    console.error("Unknown error in Apex call.");
                }
            }
        });

        // Send the action to the server
        $A.enqueueAction(action);
    }
})
