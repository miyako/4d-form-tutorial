// SVG Draw Tool - Form method
// Handles On Load (initialize blank SVG) and On Timer (track mouse during draw/select)

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
		DOM SET XML ATTRIBUTE($bg; "id"; "background"; "width"; "100%"; "height"; "100%"; "fill"; "white")
		
		// Export to picture and assign to form data source
		var $pic : Picture
		SVG EXPORT TO PICTURE($dom; $pic)
		Form.SVG:=$pic
		
		// Store DOM reference for later use
		Form.dom:=$dom
		Form.lineCount:=0
		Form.polyPoints:=Null
		
		// Default tool: select
		Form.toolSelect:=1
		Form.toolLine:=0
		Form.toolRect:=0
		Form.toolEllipse:=0
		Form.toolPolyline:=0
		Form.tool:="select"
		
	: ($event.code=On Timer)
		// Track mouse position during drawing/selection
		var $mouseX; $mouseY; $mouseB : Integer
		MOUSE POSITION($mouseX; $mouseY; $mouseB; *)
		
		// Convert screen coords to form-relative
		CONVERT COORDINATES($mouseX; $mouseY; XY Screen; XY Current form)
		
		// Subtract object origin for object-relative coords
		var $left; $top; $right; $bottom : Integer
		OBJECT GET COORDINATES(*; "canvas"; $left; $top; $right; $bottom)
		$mouseX:=$mouseX-$left
		$mouseY:=$mouseY-$top
		
		Case of
			: (Form.tool="line")
				// LINE TOOL
				If (Bool($mouseB))
					SVG SET ATTRIBUTE(*; "canvas"; "currentLine"; "x2"; String($mouseX); "y2"; String($mouseY))
				Else
					SET TIMER(0)
					
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
					
					SVG EXPORT TO PICTURE(Form.dom; $pic)
					Form.SVG:=$pic
				End if
				
			: (Form.tool="rect")
				// RECT TOOL
				var $rx; $ry; $rw; $rh : Integer
				var $sXi; $sYi : Integer
				$sXi:=Num(Form.startX)
				$sYi:=Num(Form.startY)
				If ($mouseX<$sXi)
					$rx:=$mouseX
				Else
					$rx:=$sXi
				End if
				If ($mouseY<$sYi)
					$ry:=$mouseY
				Else
					$ry:=$sYi
				End if
				$rw:=Abs($mouseX-$sXi)
				$rh:=Abs($mouseY-$sYi)
				
				If (Bool($mouseB))
					SVG SET ATTRIBUTE(*; "canvas"; "currentRect"; \
						"x"; String($rx); \
						"y"; String($ry); \
						"width"; String($rw); \
						"height"; String($rh))
				Else
					SET TIMER(0)
					Form.lineCount:=Form.lineCount+1
					var $rectEl : Text
					$rectEl:=DOM Create XML element(Form.dom; "rect")
					DOM SET XML ATTRIBUTE($rectEl; \
						"id"; "rect"+String(Form.lineCount); \
						"x"; String($rx); \
						"y"; String($ry); \
						"width"; String($rw); \
						"height"; String($rh); \
						"fill"; "none"; \
						"stroke"; "black"; \
						"stroke-width"; "2")
					
					SVG EXPORT TO PICTURE(Form.dom; $pic)
					Form.SVG:=$pic
				End if
				
			: (Form.tool="ellipse")
				// ELLIPSE TOOL
				var $ecx; $ecy; $erx; $ery : Integer
				var $esXi; $esYi : Integer
				$esXi:=Num(Form.startX)
				$esYi:=Num(Form.startY)
				$ecx:=($esXi+$mouseX)/2
				$ecy:=($esYi+$mouseY)/2
				$erx:=Abs($mouseX-$esXi)/2
				$ery:=Abs($mouseY-$esYi)/2
				
				If (Bool($mouseB))
					SVG SET ATTRIBUTE(*; "canvas"; "currentEllipse"; \
						"cx"; String($ecx); \
						"cy"; String($ecy); \
						"rx"; String($erx); \
						"ry"; String($ery))
				Else
					SET TIMER(0)
					Form.lineCount:=Form.lineCount+1
					var $ellEl : Text
					$ellEl:=DOM Create XML element(Form.dom; "ellipse")
					DOM SET XML ATTRIBUTE($ellEl; \
						"id"; "ellipse"+String(Form.lineCount); \
						"cx"; String($ecx); \
						"cy"; String($ecy); \
						"rx"; String($erx); \
						"ry"; String($ery); \
						"fill"; "none"; \
						"stroke"; "black"; \
						"stroke-width"; "2")
					
					SVG EXPORT TO PICTURE(Form.dom; $pic)
					Form.SVG:=$pic
				End if
				
			Else
				// SELECT TOOL
				If (Bool($mouseB))
					var $sx; $sy; $sw; $sh : Integer
					var $startXi; $startYi : Integer
					$startXi:=Num(Form.startX)
					$startYi:=Num(Form.startY)
					If ($mouseX<$startXi)
						$sx:=$mouseX
					Else
						$sx:=$startXi
					End if
					If ($mouseY<$startYi)
						$sy:=$mouseY
					Else
						$sy:=$startYi
					End if
					$sw:=Abs($mouseX-$startXi)
					$sh:=Abs($mouseY-$startYi)
					SVG SET ATTRIBUTE(*; "canvas"; "selRect"; \
						"x"; String($sx); \
						"y"; String($sy); \
						"width"; String($sw); \
						"height"; String($sh))
					
					// Live highlight: find intersecting elements
					ARRAY TEXT($ids; 0)
					var $found : Boolean
					$found:=SVG Find element IDs by rect(*; "canvas"; $sx; $sy; $sw; $sh; $ids)
					
					var $i : Integer
					For ($i; 1; Form.lineCount)
						SVG SET ATTRIBUTE(*; "canvas"; "line"+String($i); "stroke"; "black")
					End for
					
					For ($i; 1; Size of array($ids))
						If ($ids{$i}#"background") & ($ids{$i}#"selRect")
							SVG SET ATTRIBUTE(*; "canvas"; $ids{$i}; "stroke"; "red")
						End if
					End for
					
				Else
					SET TIMER(0)
					SVG SET ATTRIBUTE(*; "canvas"; "selRect"; "width"; "0"; "height"; "0")
				End if
		End case
		
	: ($event.code=On Unload)
		// Clean up DOM reference
		If (Form.dom#"")
			DOM CLOSE XML(Form.dom)
		End if
		
End case
