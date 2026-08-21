var $event : Object
$event:=FORM Event:C1606

Case of 
	: ($event.code=On Data Change:K2:15)
		
		Form:C1466.info:=$event.description
		
	: ($event.code=On Clicked:K2:4)
		
		Form:C1466.info:=$event.description
		
End case 