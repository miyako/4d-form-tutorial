var $event:=FORM Event

Case of 
	: ($event.code=On Clicked)
		
		Form.appendLog("⌘K shortcut triggered!")
		
End case 
