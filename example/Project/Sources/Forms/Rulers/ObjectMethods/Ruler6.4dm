var $event : Object
$event:=FORM Event:C1606

Case of 
	: ($event.code=On Data Change:K2:15)
		
		ALERT:C41($event.description)
		
End case 