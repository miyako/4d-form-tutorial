var $event : Object

$event:=FORM Event:C1606

Case of 
	: ($event.code=On Load:K2:1)
		
		Form:C1466.info:=""
		
	: ($event.code=On Drag Over:K2:13) || \
		($event.code=On After Edit:K2:43) || \
		($event.code=On Data Change:K2:15) || \
		($event.code=On Selection Change:K2:29)
		
		Form:C1466.info+=$event.description
		
	: ($event.code=On Drop:K2:12)
		
		Form:C1466.info:=$event.description
		
End case 
