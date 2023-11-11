%dw 2.5
input scan application/json
output application/apex
---
// should return an array of Search_Logs__c object

scan.Items map (item) -> {
    Device_Type__c: item.DeviceType.S,
    Search_Term__c: item.Term.S,
    Last_Updated__c: item.LastUpdated.S as DateTime,
    Search_Results_Count__c: item.SearchResultCount.N as Number,
    // TODO: format to match DateTime Salesforce
    Search_Time_Stamp__c: item.SearchTimeStamp.S as DateTime,
    SessionId__c: item.SessionId.S,
    User_City__c: item.UserCity.S,
    User_IP__c: item.UserIp.S,
    Applied_Filters__c: (item.FilterApplied.L map (item) -> item.S) joinBy  "|"
} as Object {class: "Search_Log__c"}
