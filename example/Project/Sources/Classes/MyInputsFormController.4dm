property _today : Date
property txt1 : Text
property txt2 : Text
property txt3 : Text
property txt4 : Text
property alpha1 : Text
property styled1 : Text
property bool1 : Boolean
property date1 : Date
property num1 : Real
property pic1 : Picture
property choice1 : Text
property srcFilter : Text
property dstFilter : Text
property srcEnterable : Text
property dstEnterable : Text
property srcPic : Picture
property src : Picture
property dst : Picture

Class constructor
	
	This:C1470._today:=Current date:C33
	
Function get today() : Date
	
	return This:C1470._today