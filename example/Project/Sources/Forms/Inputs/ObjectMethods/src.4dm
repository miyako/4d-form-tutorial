var $event : Object
$event:=FORM Event:C1606

Case of 
	: ($event.code=On Load:K2:1)
		
		var $file : 4D:C1709.File
		$file:=File:C1566("/RESOURCES/images/grid2x2.png")
		var $image : Picture
		READ PICTURE FILE:C678($file.platformPath; $image)
		Form:C1466.src:=$image
		
	: ($event.code=On Begin Drag Over:K2:44)
		
		OBJECT SET TITLE:C194(*; "title.src"; $event.description)
		
		var $data : Blob
		$info:={foo: "bar"}
		VARIABLE TO BLOB:C532($info; $data)
		
		SET PICTURE TO PASTEBOARD:C521(Form:C1466.src)
		APPEND DATA TO PASTEBOARD:C403("private.myapp.data"; $data)
		
		var $icon : Picture
		CREATE THUMBNAIL:C679(Form:C1466.src; $icon; 32; 32)
		SET DRAG ICON:C1272($icon)
		
End case 