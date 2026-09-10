var $event : Object
$event:=FORM Event:C1606

Case of 
	: ($event.code=On Load:K2:1)
		
	: ($event.code=On Unload:K2:2)
		
	: ($event.code=On Page Change:K2:54)
		
		GOTO OBJECT:C206(*; "")
		
End case 