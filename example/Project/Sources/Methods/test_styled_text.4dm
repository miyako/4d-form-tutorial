//%attributes = {"invisible":true}
// Run the StyledText form with DIALOG to execute On Load code,
// then screenshot each page.

var $formName : Text
$formName:="StyledText"

var $width; $height; $pages : Integer
FORM GET PROPERTIES($formName; $width; $height; $pages)

// Use FORM LOAD to trigger the form method (On Load)
FORM LOAD($formName)
FORM GOTO PAGE(1)

var $screenshot : Picture
var $file : 4D.File

var $i : Integer
For ($i; 1; $pages)
	FORM GOTO PAGE($i)
	FORM SCREENSHOT($screenshot)
	$file:=File("/RESOURCES/tests/StyledText_page"+String($i)+".png")
	$file.parent.create()
	WRITE PICTURE FILE($file.platformPath; $screenshot)
	LOG EVENT(Into system standard outputs; "Saved: "+$file.path; Information message)
End for 

FORM UNLOAD

If (Application info.headless)
	QUIT 4D
End if 
