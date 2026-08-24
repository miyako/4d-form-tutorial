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
		
		//var $data : Blob
		//var $info : Object
		//$info:={foo: "bar"}
		//VARIABLE TO BLOB($info; $data)
		
		//SET PICTURE TO PASTEBOARD(Form.src)
		//APPEND DATA TO PASTEBOARD("private.myapp.data"; $data)
		
		$file:=File:C1566("/RESOURCES/images/grid2x2.png")
		SET FILE TO PASTEBOARD:C975($file.platformPath)
		
		var $icon : Picture
		CREATE THUMBNAIL:C679(Form:C1466.src; $icon; 32; 32)
		SET DRAG ICON:C1272($icon)
		
End case 