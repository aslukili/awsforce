%dw 2.5
input payload application/json
output application/json
---
{ 
   Content: { 
      Simple: { 
         Body: { 
            Text: { 
               Data: payload.message
            }
         },
         Subject: { 
            Charset: "UTF-8",
            Data: payload.subject
         }
      }
   },
   Destination: { 
      ToAddresses: payload.toAddresses
   },
   EmailTags: [ 
      { 
         Name: "tag1",
         Value: "value1"
      }
   ],
   FromEmailAddress: "abdeslamhq@gmail.com"
}