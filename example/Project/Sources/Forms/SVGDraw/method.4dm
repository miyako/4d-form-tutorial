// SVG Draw Tool - Form method
// Handles On Load (initialize blank SVG) and On Timer (track mouse during draw)

var $event : cs:C1710.FormEvent
$event:=FORM Event:C1606

Case of
	: ($event.code=On Load:K2:1)
		// Create a blank SVG document
		var $dom : Text
		$dom:=DOM Create XML Ref:C861("svg"; "http://www.w3.org/2000/svg")
		DOM SET XML ATTRIBUTE:C866($dom; "width"; "500"; "height"; "400"; "xmlns"; "http://www.w3.org/2000/svg")
		
		// Add a white background rectangle
		var $bg : Text
		$bg:=DOM Create XML element:C865($dom; "rect")
		DOM SET XML ATTRIBUTE:C866($bg; "width"; "100%"; "height"; "100%"; "fill"; "white")
		
		// Export to picture and assign to form data source
		var $pic : Picture
		SVG EXPORT TO PICTURE:C1017($dom; $pic; Is SVG:K25:1)
		Form:C1466.SVG:=$pic
		
		// Store DOM reference for later use
		Form:C1466.dom:=$dom
		Form:C1466.lineCount:=0
		
	: ($event.code=On Timer:K2:27)
		// Track mouse position during drawing
		var $mouseX; $mouseY; $mouseB : Integer
		GET MOUSE:C468($mouseX; $mouseY; $mouseB; *)
		
		// Convert screen coords to form-relative
		CONVERT COORDINATES:C1365($mouseX; $mouseY; XY Screen:K23:1; XY Current form:K23:2)
		
		// Subtract object origin for object-relative coords
		var $left; $top; $right; $bottom : Integer
		OBJECT GET COORDINATES:C663(*; "canvas"; $left; $top; $right; $bottom)
		$mouseX:=$mouseX-$left
		$mouseY:=$mouseY-$top
		
		If (Bool:C1537($mouseB))
			// Mouse button still held - update the current line's endpoint (rendering tree only)
			SVG SET ATTRIBUTE:C1055(*; "canvas"; "currentLine"; "x2"; String:C10($mouseX); "y2"; String:C10($mouseY))
		Else
			// Mouse button released - finalize the line
			SET TIMER:C645(0)
			
			// Commit the line to DOM tree with final coordinates
			var $x2Str; $y2Str : Text
			$x2Str:=String:C10($mouseX)
			$y2Str:=String:C10($mouseY)
			
			var $line : Text
			$line:=DOM Create XML element:C865(Form:C1466.dom; "line")
			Form:C1466.lineCount:=Form:C1466.lineCount+1
			DOM SET XML ATTRIBUTE:C866($line; \
				"id"; "line"+String:C10(Form:C1466.lineCount); \
				"x1"; Form:C1466.startX; \
				"y1"; Form:C1466.startY; \
				"x2"; $x2Str; \
				"y2"; $y2Str; \
				"stroke"; "black"; \
				"stroke-width"; "2")
			
			// Re-export the DOM to picture
			var $pic : Picture
			SVG EXPORT TO PICTURE:C1017(Form:C1466.dom; $pic; Is SVG:K25:1)
			Form:C1466.SVG:=$pic
		End if
		
	: ($event.code=On Unload:K2:24)
		// Clean up DOM reference
		If (Form:C1466.dom#"")
			DOM CLOSE XML:C722(Form:C1466.dom)
		End if
		
End case
