var $event : Object
$event:=FORM Event:C1606

Case of 
	: ($event.code=On Clicked:K2:4)
		
		ALERT:C41($event.description)
		
	: ($event.code=On Double Clicked:K2:5)
		
		ALERT:C41($event.description)
		
	: ($event.code=On Long Click:K2:37)
		
		var $item : Integer
		$item:=Pop up menu:C542("item 1;item 2;item 3")
		
		Case of 
			: ($item=0)
				//no item selected
			: ($item=1)
				ALERT:C41("item 1")
			: ($item=2)
				ALERT:C41("item 2")
			: ($item=3)
				ALERT:C41("item 3")
		End case 
		
	: ($event.code=On Alternative Click:K2:36)
		
		var $menu : Text
		$menu:=Create menu:C408
		APPEND MENU ITEM:C411($menu; "item 1")
		SET MENU ITEM PARAMETER:C1004($menu; -1; "one")
		var $parameter : Text
		$parameter:=Dynamic pop up menu:C1006($menu)
		RELEASE MENU:C978($menu)
		
		Case of 
			: ($parameter="")
				//no item selected
			: ($parameter="one")
				ALERT:C41("item 1")
		End case 
		
End case 

