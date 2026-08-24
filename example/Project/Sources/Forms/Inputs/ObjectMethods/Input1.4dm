var $event : Object
$event:=FORM Event

Case of 
	: (($event.code=On Clicked) && (Contextual click))
		var $menu : Text
		$menu:=Create menu
		APPEND MENU ITEM($menu; "Copy")
		SET MENU ITEM PARAMETER($menu; -1; "copy")
		var $parameter : Text
		$parameter:=Dynamic pop up menu($menu)
		RELEASE MENU($menu)
		
		If ($parameter="copy")
			var $ptr : Pointer
			$ptr:=OBJECT Get pointer(Object named; $event.objectName)
			SET TEXT TO PASTEBOARD(String($ptr->))
		End If 
		
End case 
