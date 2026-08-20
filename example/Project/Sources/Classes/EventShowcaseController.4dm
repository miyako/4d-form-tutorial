property log : Text
property clickCount : Integer

Class constructor
	
	This:C1470.log:=""
	This:C1470.clickCount:=0

Function appendLog($message : Text) : cs:C1710.EventShowcaseController
	
	This:C1470.log+=$message+"\r"
	
	return This:C1470

Function onClicked() : cs:C1710.EventShowcaseController
	
	This:C1470.clickCount+=1
	This:C1470.appendLog("On Clicked ×"+String:C10(Clickcount:C1332)+" (total: "+String:C10(This:C1470.clickCount)+")")
	
	return This:C1470

Function onDoubleClicked() : cs:C1710.EventShowcaseController
	
	This:C1470.clickCount+=1
	This:C1470.appendLog("On Double Clicked (total: "+String:C10(This:C1470.clickCount)+")")
	
	return This:C1470

Function onShiftClicked() : cs:C1710.EventShowcaseController
	
	This:C1470.clickCount+=1
	This:C1470.appendLog("Shift+Click (total: "+String:C10(This:C1470.clickCount)+")")
	
	return This:C1470

Function onCommandClicked() : cs:C1710.EventShowcaseController
	
	This:C1470.clickCount+=1
	This:C1470.appendLog("⌘+Click (total: "+String:C10(This:C1470.clickCount)+")")
	
	return This:C1470

Function onContextualClicked() : cs:C1710.EventShowcaseController
	
	This:C1470.clickCount+=1
	This:C1470.appendLog("Contextual Click (total: "+String:C10(This:C1470.clickCount)+")")
	
	return This:C1470

Function clearLog() : cs:C1710.EventShowcaseController
	
	This:C1470.log:=""
	This:C1470.clickCount:=0
	
	return This:C1470
