var $event : Object
$event:=FORM Event:C1606

Case of 
	: (($event.code=On Clicked:K2:4) && (Contextual click:C713))
		
		var $focusObjectName : Text
		$focusObjectName:=OBJECT Get name:C1087(Object with focus:K67:3)
		var $start; $end : Integer
		GET HIGHLIGHT:C209(*; $focusObjectName; $start; $end)
		var $selectedValue : Text
		$selectedValue:=Substring:C12(Get edited text:C655; $start; $end-$start)
		
		
		
		If ($selectedValue#"")
			
			var $menu : Text
			$menu:=Create menu:C408
			APPEND MENU ITEM:C411($menu; "Copy")
			SET MENU ITEM PARAMETER:C1004($menu; -1; "copy")
			
			var $parameter : Text
			$parameter:=Dynamic pop up menu:C1006($menu)
			RELEASE MENU:C978($menu)
			
			If ($parameter="copy")
				SET TEXT TO PASTEBOARD:C523($selectedValue)
			End if 
			
		End if 
		
End case 
