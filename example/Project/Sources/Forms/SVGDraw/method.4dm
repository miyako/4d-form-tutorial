// SVG Draw Tool - Form method
// Handles On Load (initialize blank SVG) and On Timer (track mouse during draw)

var $event : Object
$event:=FORM Event

Case of
	: ($event.code=On Load)
		// Create a blank SVG document
		var $dom : Text
		$dom:=DOM Create XML Ref("svg"; "http://www.w3.org/2000/svg")
		DOM SET XML ATTRIBUTE($dom; "width"; "500"; "height"; "400"; "xmlns"; "http://www.w3.org/2000/svg")
		
		// Add a white background rectangle
		var $bg : Text
		$bg:=DOM Create XML element($dom; "rect")
		DOM SET XML ATTRIBUTE($bg; "width"; "100%"; "height"; "100%"; "fill"; "white")
		
		// Export to picture and assign to form data source
		var $pic : Picture
		SVG EXPORT TO PICTURE($dom; $pic)
		Form.SVG:=$pic
		
		// Store DOM reference for later use
		Form.dom:=$dom
		Form.lineCount:=0
		
	: ($event.code=On Timer)
		// Track mouse position during drawing
		var $mouseX; $mouseY; $mouseB : Integer
		MOUSE POSITION($mouseX; $mouseY; $mouseB; *)
		
		// Convert screen coords to form-relative
		CONVERT COORDINATES($mouseX; $mouseY; XY Screen; XY Current form)
		
		// Subtract object origin for object-relative coords
		var $left; $top; $right; $bottom : Integer
		OBJECT GET COORDINATES(*; "canvas"; $left; $top; $right; $bottom)
		$mouseX:=$mouseX-$left
		$mouseY:=$mouseY-$top
		
		If (Bool($mouseB))
			// Mouse button still held - update the current line's endpoint (rendering tree only)
			SVG SET ATTRIBUTE(*; "canvas"; "currentLine"; "x2"; String($mouseX); "y2"; String($mouseY))
		Else
			// Mouse button released - finalize the line
			SET TIMER(0)
			
			// Commit the line to DOM tree with final coordinates
			var $x2Str; $y2Str : Text
			$x2Str:=String($mouseX)
			$y2Str:=String($mouseY)
			
			var $line : Text
			$line:=DOM Create XML element(Form.dom; "line")
			Form.lineCount:=Form.lineCount+1
			DOM SET XML ATTRIBUTE($line; \
				"id"; "line"+String(Form.lineCount); \
				"x1"; Form.startX; \
				"y1"; Form.startY; \
				"x2"; $x2Str; \
				"y2"; $y2Str; \
				"stroke"; "black"; \
				"stroke-width"; "2")
			
			// Re-export the DOM to picture
			SVG EXPORT TO PICTURE(Form.dom; $pic)
			Form.SVG:=$pic
		End if
		
	: ($event.code=On Unload)
		// Clean up DOM reference
		If (Form.dom#"")
			DOM CLOSE XML(Form.dom)
		End if
		
End case
