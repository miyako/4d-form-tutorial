property count : Integer
property cb1; cb2; cb3 : Integer

Class constructor
	
	This:C1470.count:=0
	This:C1470.cb1:=0
	This:C1470.cb2:=0
	This:C1470.cb3:=0
	
Function onClicked() : cs:C1710.MyFormController
	
	This:C1470.count+=1
	
	return This:C1470