//%attributes = {"invisible":true}
var $event : cs.EventObject
$event:=FORM Event

Case of 
	: ($event.code=On Getting Focus)
		// select "World" (positions 7-12)
		HIGHLIGHT TEXT(*; "st_highlight"; 7; 12)
End case 
