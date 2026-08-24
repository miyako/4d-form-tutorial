var $event : Object
$event:=FORM Event:C1606

Case of 
	: (($event.code=On Clicked:K2:4) && (Contextual click:C713))
		
		var $menu : Text
		$menu:=Create menu:C408
		APPEND MENU ITEM:C411($menu; ak standard action title:K76:83)
		SET MENU ITEM PROPERTY:C973($menu; -1; Associated standard action:K56:1; ak copy:K76:54)
		
		var $parameter : Text
		$parameter:=Dynamic pop up menu:C1006($menu)
		RELEASE MENU:C978($menu)
		
		//If ($parameter="copy")
		//var $ptr : Pointer
		//$ptr:=OBJECT Get pointer(Object named; $event.objectName)
		//SET TEXT TO PASTEBOARD(String($ptr->))
		//End if 
		
End case 
