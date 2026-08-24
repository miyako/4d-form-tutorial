var $event : Object
$event:=FORM Event:C1606

Case of 
	: ($event.code=On Drag Over:K2:13)
		
		OBJECT SET TITLE:C194(*; "title.dst"; $event.description)
		
		var $i : Integer
		var $path : Text
		
		$i:=0
		Repeat 
			$i+=1
			$path:=Get file from pasteboard:C976($i)
			If (Is picture file:C1113($path))
				return 0
			End if 
		Until ($path="")
		
		return -1
		
	: ($event.code=On Drop:K2:12)
		
		OBJECT SET TITLE:C194(*; "title.dst"; $event.description)
		
		$i:=0
		Repeat 
			$i+=1
			$path:=Get file from pasteboard:C976($i)
			If (Is picture file:C1113($path))
				var $image : Picture
				READ PICTURE FILE:C678($path; $image)
				Form:C1466.dst:=$image
				return 
			End if 
		Until ($path="")
		
End case 