var $event:=FORM Event:C1606

Case of 
	: ($event.code=On Clicked:K2:4)
		
		Form:C1466.appendLog("⌘K shortcut triggered!")
		
End case 
