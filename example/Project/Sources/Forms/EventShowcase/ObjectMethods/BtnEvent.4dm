var $event:=FORM Event

Case of 
	: ($event.code=On Double Clicked)
		
		Form.onDoubleClicked()
		
	: (($event.code=On Clicked) && Contextual click)
		
		Form.onContextualClicked()
		
	: (($event.code=On Clicked) && Shift down)
		
		Form.onShiftClicked()
		
	: (($event.code=On Clicked) && Macintosh command down)
		
		Form.onCommandClicked()
		
	: ($event.code=On Clicked)
		
		Form.onClicked()
		
End case 
