var $event:=FORM Event:C1606

Case of 
	: ($event.code=On Double Clicked:K2:5)
		
		Form:C1466.onDoubleClicked()
		
	: (($event.code=On Clicked:K2:4) && Contextual click:C713)
		
		Form:C1466.onContextualClicked()
		
	: (($event.code=On Clicked:K2:4) && Shift down:C543)
		
		Form:C1466.onShiftClicked()
		
	: (($event.code=On Clicked:K2:4) && Macintosh command down:C546)
		
		Form:C1466.onCommandClicked()
		
	: ($event.code=On Clicked:K2:4)
		
		Form:C1466.onClicked()
		
End case 
