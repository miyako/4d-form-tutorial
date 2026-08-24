var $event : Object
$event:=FORM Event:C1606

Case of 
	: ($event.code=On Drag Over:K2:13)
		
		OBJECT SET TITLE:C194(*; "title.dst"; $event.description)
		
		If (Pasteboard data size:C400("private.myapp.data")>0)
			return 0
		Else 
			return -1
		End if 
		
	: ($event.code=On Drop:K2:12)
		
		OBJECT SET TITLE:C194(*; "title.dst"; $event.description)
		
		var $image : Picture
		GET PICTURE FROM PASTEBOARD:C522($image)
		Form:C1466.dst:=$image
		
End case 