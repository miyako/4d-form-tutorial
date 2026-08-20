property log : Text
property clickCount : Integer

Class constructor
	
	This.log:=""
	This.clickCount:=0

Function appendLog($message : Text) : cs.EventShowcaseController
	
	This.log+=$message+"\r"
	
	return This

Function onClicked() : cs.EventShowcaseController
	
	This.clickCount+=1
	This.appendLog("On Clicked ×"+String(Clickcount)+" (total: "+String(This.clickCount)+")")
	
	return This

Function onDoubleClicked() : cs.EventShowcaseController
	
	This.clickCount+=1
	This.appendLog("On Double Clicked (total: "+String(This.clickCount)+")")
	
	return This

Function onShiftClicked() : cs.EventShowcaseController
	
	This.clickCount+=1
	This.appendLog("Shift+Click (total: "+String(This.clickCount)+")")
	
	return This

Function onCommandClicked() : cs.EventShowcaseController
	
	This.clickCount+=1
	This.appendLog("⌘+Click (total: "+String(This.clickCount)+")")
	
	return This

Function onContextualClicked() : cs.EventShowcaseController
	
	This.clickCount+=1
	This.appendLog("Contextual Click (total: "+String(This.clickCount)+")")
	
	return This

Function clearLog() : cs.EventShowcaseController
	
	This.log:=""
	This.clickCount:=0
	
	return This
