// SVG Draw Tool - Canvas object method
// Handles On Load and On Clicked events

var $event : Object
$event:=FORM Event

Case of
	: ($event.code=On Load)
		// Nothing extra needed here; form method handles initialization
		
	: ($event.code=On Clicked)
		// Record the starting point of the line
		Form.startX:=String(MouseX)
		Form.startY:=String(MouseY)
		
		// Create a temporary line in the rendering tree for live feedback
		Form.lineCount:=Form.lineCount+1
		var $lineId : Text
		$lineId:="currentLine"
		
		// Add temporary line element to DOM so rendering tree has it
		var $line : Text
		$line:=DOM Create XML element(Form.dom; "line")
		DOM SET XML ATTRIBUTE($line; \
			"id"; $lineId; \
			"x1"; Form.startX; \
			"y1"; Form.startY; \
			"x2"; Form.startX; \
			"y2"; Form.startY; \
			"stroke"; "black"; \
			"stroke-width"; "2")
		
		// Re-export so the rendering tree has the new element
		var $pic : Picture
		SVG EXPORT TO PICTURE(Form.dom; $pic)
		Form.SVG:=$pic
		
		// Remove it from DOM (we'll add the final version on mouse-up)
		DOM REMOVE XML ELEMENT($line)
		
		// Decrement since we'll re-increment on finalize
		Form.lineCount:=Form.lineCount-1
		
		// Start timer for continuous mouse tracking
		SET TIMER(-1)
		
End case
