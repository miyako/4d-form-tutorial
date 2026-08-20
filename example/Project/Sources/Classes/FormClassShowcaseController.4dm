property clickCount : Integer
property message : Text

Class constructor
	
	This.clickCount:=0
	This.message:="No clicks yet"

Function increment() : cs.FormClassShowcaseController
	
	This.clickCount+=1
	This.message:="Clicked "+String(This.clickCount)+" time"
	If (This.clickCount>1)
		This.message+="s"
	End if 
	
	return This
