// SVG Draw Tool - Canvas object method
// Handles On Load and On Clicked events

var $event : cs:C1710.FormEvent
$event:=FORM Event:C1606

Case of
	: ($event.code=On Load:K2:1)
		// Nothing extra needed here; form method handles initialization
		
	: ($event.code=On Clicked:K2:4)
		// Record the starting point of the line
		Form:C1466.startX:=String:C10(MouseX:C220)
		Form:C1466.startY:=String:C10(MouseY:C221)
		
		// Create a temporary line in the rendering tree for live feedback
		Form:C1466.lineCount:=Form:C1466.lineCount+1
		var $lineId : Text
		$lineId:="currentLine"
		
		// Add temporary line element to DOM so rendering tree has it
		var $line : Text
		$line:=DOM Create XML element:C865(Form:C1466.dom; "line")
		DOM SET XML ATTRIBUTE:C866($line; \
			"id"; $lineId; \
			"x1"; Form:C1466.startX; \
			"y1"; Form:C1466.startY; \
			"x2"; Form:C1466.startX; \
			"y2"; Form:C1466.startY; \
			"stroke"; "black"; \
			"stroke-width"; "2")
		
		// Re-export so the rendering tree has the new element
		var $pic : Picture
		SVG EXPORT TO PICTURE:C1017(Form:C1466.dom; $pic; Is SVG:K25:1)
		Form:C1466.SVG:=$pic
		
		// Remove it from DOM (we'll add the final version on mouse-up)
		DOM REMOVE XML ELEMENT:C869($line)
		
		// Decrement since we'll re-increment on finalize
		Form:C1466.lineCount:=Form:C1466.lineCount-1
		
		// Start timer for continuous mouse tracking
		SET TIMER:C645(-1)
		
End case
