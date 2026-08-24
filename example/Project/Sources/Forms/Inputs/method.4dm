var $event : Object
$event:=FORM Event:C1606

Case of 
	: ($event.code=On Load:K2:1)
		
		Form:C1466.txt1:="Sample text"
		Form:C1466.txt2:="Read-only display value"
		Form:C1466.txt3:="Line one\nLine two\nA long line that should wrap automatically when wordwrap is enabled for a multiline input area."
		Form:C1466.txt4:="12345"
		var $picture : Picture
		READ PICTURE FILE:C678(Get 4D folder:C485(Current resources folder:K5:16)+"Images"+Folder separator:K24:12+"grid2x2.png"; $picture)
		Form:C1466.pic1:=$picture
		Form:C1466.bool1:=True:C214
		Form:C1466.date1:=!2024-03-25!
		Form:C1466.num1:=1234.5
		Form:C1466.choice1:="Green"
		Form:C1466.alpha1:="5551234567"
		Form:C1466.styled1:="Styled input"
		
		Form:C1466.srcFilter:="abc123"
		Form:C1466.dstFilter:=""
		
		Form:C1466.srcEnterable:="Drop me"
		Form:C1466.dstEnterable:=""
		
		var $picture2 : Picture
		READ PICTURE FILE:C678(Get 4D folder:C485(Current resources folder:K5:16)+"Images"+Folder separator:K24:12+"grid2x2.png"; $picture2)
		Form:C1466.srcPic:=$picture2
		
	: ($event.code=On Unload:K2:2)
		
	: ($event.code=On Page Change:K2:54)
		
		GOTO OBJECT:C206(*; "")
		
End case 
