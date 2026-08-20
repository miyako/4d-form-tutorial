property clickCount : Integer
property message : Text

Class constructor
	
	This:C1470.clickCount:=0
	This:C1470.message:="No clicks yet"

Function increment() : cs:C1710.FormClassShowcaseController
	
	This:C1470.clickCount+=1
	This:C1470.message:="Clicked "+String:C10(This:C1470.clickCount)+" time"
	If (This:C1470.clickCount>1)
		This:C1470.message+="s"
	End if 
	
	return This:C1470
