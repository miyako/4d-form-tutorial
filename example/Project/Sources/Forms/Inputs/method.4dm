var $event : Object
$event:=FORM Event

Case of 
	: ($event.code=On Load)
		
		Form.txt1:="Sample text"
		Form.txt2:="Read-only display value"
		Form.txt3:="Line one\nLine two\nA long line that should wrap automatically when wordwrap is enabled for a multiline input area."
		Form.txt4:="12345"
		Form.pic1:=Read picture file(Get 4D folder(Current resources folder)+"Images"+Folder separator+"grid2x2.png")
		Form.bool1:=True
		Form.date1:=!2024-03-25!
		Form.num1:=1234.5
		Form.choice1:="Green"
		Form.alpha1:="5551234567"
		Form.styled1:="Styled input"
		
	: ($event.code=On Unload)
		
End case
