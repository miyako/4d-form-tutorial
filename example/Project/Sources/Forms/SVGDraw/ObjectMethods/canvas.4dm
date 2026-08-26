// SVG Draw Tool - Canvas object method
// Handles On Clicked: starts line draw or selection depending on active tool

var $event : Object
$event:=FORM Event

Case of
	: ($event.code=On Clicked)
		// Record the starting point
		Form.startX:=String(MouseX)
		Form.startY:=String(MouseY)
		
		If (Form.tool="line")
			// LINE TOOL: create a temporary line in the rendering tree
			var $line : Text
			$line:=DOM Create XML element(Form.dom; "line")
			DOM SET XML ATTRIBUTE($line; \
				"id"; "currentLine"; \
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
			
			// Remove from DOM (final version added on mouse-up)
			DOM REMOVE XML ELEMENT($line)
			
		Else
			// SELECT TOOL: create a temporary selection rectangle
			var $rect : Text
			$rect:=DOM Create XML element(Form.dom; "rect")
			DOM SET XML ATTRIBUTE($rect; \
				"id"; "selRect"; \
				"x"; Form.startX; \
				"y"; Form.startY; \
				"width"; "0"; \
				"height"; "0"; \
				"fill"; "rgba(0,120,255,0.1)"; \
				"stroke"; "blue"; \
				"stroke-width"; "1"; \
				"stroke-dasharray"; "4,4")
			
			// Re-export so the rendering tree has the element
			var $pic2 : Picture
			SVG EXPORT TO PICTURE(Form.dom; $pic2)
			Form.SVG:=$pic2
			
			// Remove from DOM (it's only for visual feedback)
			DOM REMOVE XML ELEMENT($rect)
		End if
		
		// Start timer for continuous mouse tracking
		SET TIMER(-1)
		
End case
