// SVG Draw Tool - Form method
// Handles On Load (initialize blank SVG) and On Timer (track mouse during draw/select)

var $event : Object
$event:=FORM Event

Case of
	: ($event.code=On Load)
		// Create a blank SVG document
		var $dom : Text
		$dom:=DOM Create XML Ref("svg"; "http://www.w3.org/2000/svg")
		DOM SET XML ATTRIBUTE($dom; "width"; "500"; "height"; "400"; "xmlns"; "http://www.w3.org/2000/svg"; "viewport-fill"; "white"; "viewport-fill-opacity"; "0")
		
		// Export to picture and assign to form data source
		var $pic : Picture
		SVG EXPORT TO PICTURE($dom; $pic)
		Form.SVG:=$pic
		
		// Store DOM reference for later use
		Form.dom:=$dom
		Form.lineCount:=0
		Form.polyPoints:=Null
		
		// Detect stroke color from CSS (adapts to dark/light mode)
		var $fg; $bg : Integer
		OBJECT GET RGB COLORS(*; "refStroke"; $fg; $bg)
		var $r; $g; $b : Integer
		$r:=($bg >> 16) & 0x0000FF
		$g:=($bg >> 8) & 0x0000FF
		$b:=$bg & 0x0000FF
		Form.strokeColor:="rgb("+String($r)+","+String($g)+","+String($b)+")"
		
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
				// LINE TOOL — Shift constrains to horizontal/vertical
				var $lx; $ly : Integer
				$lx:=$mouseX
				$ly:=$mouseY
				If (Shift down)
					var $adx; $ady : Integer
					$adx:=Abs($mouseX-Num(Form.startX))
					$ady:=Abs($mouseY-Num(Form.startY))
					If ($adx>=$ady)
						$ly:=Num(Form.startY)
					Else
						$lx:=Num(Form.startX)
					End if
				End if
				
				If (Bool($mouseB))
					SVG SET ATTRIBUTE(*; "canvas"; "currentLine"; "x2"; String($lx); "y2"; String($ly))
				Else
					SET TIMER(0)
					
					var $x2Str; $y2Str : Text
					$x2Str:=String($lx)
					$y2Str:=String($ly)
					
					var $line : Text
					$line:=DOM Create XML element(Form.dom; "line")
					Form.lineCount:=Form.lineCount+1
					DOM SET XML ATTRIBUTE($line; \
						"id"; "line"+String(Form.lineCount); \
						"x1"; Form.startX; \
						"y1"; Form.startY; \
						"x2"; $x2Str; \
						"y2"; $y2Str; \
						"stroke"; Form.strokeColor; \
						"stroke-width"; "2")
					
					SVG EXPORT TO PICTURE(Form.dom; $pic)
					Form.SVG:=$pic
				End if
				
			: (Form.tool="rect")
				// RECT TOOL — Shift constrains to square
				var $rx; $ry; $rw; $rh : Integer
				var $sXi; $sYi : Integer
				$sXi:=Num(Form.startX)
				$sYi:=Num(Form.startY)
				$rw:=Abs($mouseX-$sXi)
				$rh:=Abs($mouseY-$sYi)
				
				If (Shift down)
					If ($rw>$rh)
						$rh:=$rw
					Else
						$rw:=$rh
					End if
				End if
				
				If ($mouseX<$sXi)
					$rx:=$sXi-$rw
				Else
					$rx:=$sXi
				End if
				If ($mouseY<$sYi)
					$ry:=$sYi-$rh
				Else
					$ry:=$sYi
				End if
				
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
						"stroke"; Form.strokeColor; \
						"stroke-width"; "2")
					
					SVG EXPORT TO PICTURE(Form.dom; $pic)
					Form.SVG:=$pic
				End if
				
			: (Form.tool="ellipse")
				// ELLIPSE TOOL — Shift constrains to circle
				var $ecx; $ecy; $erx; $ery : Integer
				var $esXi; $esYi : Integer
				$esXi:=Num(Form.startX)
				$esYi:=Num(Form.startY)
				$erx:=Abs($mouseX-$esXi)/2
				$ery:=Abs($mouseY-$esYi)/2
				
				If (Shift down)
					If ($erx>$ery)
						$ery:=$erx
					Else
						$erx:=$ery
					End if
				End if
				
				var $emx; $emy : Integer
				If ($mouseX<$esXi)
					$emx:=$esXi-($erx*2)
				Else
					$emx:=$mouseX
				End if
				If ($mouseY<$esYi)
					$emy:=$esYi-($ery*2)
				Else
					$emy:=$mouseY
				End if
				$ecx:=($esXi+$emx)/2
				$ecy:=($esYi+$emy)/2
				
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
						"stroke"; Form.strokeColor; \
						"stroke-width"; "2")
					
					SVG EXPORT TO PICTURE(Form.dom; $pic)
					Form.SVG:=$pic
				End if
				
			: (Form.tool="polyline")
				// POLYLINE TOOL: update tracking line — Shift constrains to H/V
				var $plx; $ply : Integer
				$plx:=$mouseX
				$ply:=$mouseY
				If (Shift down)
					var $pdx; $pdy : Integer
					$pdx:=Abs($mouseX-Num(Form.polyLastX))
					$pdy:=Abs($mouseY-Num(Form.polyLastY))
					If ($pdx>=$pdy)
						$ply:=Num(Form.polyLastY)
					Else
						$plx:=Num(Form.polyLastX)
					End if
				End if
				SVG SET ATTRIBUTE(*; "canvas"; "trackLine"; "x2"; String($plx); "y2"; String($ply))
				
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
						SVG SET ATTRIBUTE(*; "canvas"; "line"+String($i); "stroke"; Form.strokeColor)
					End for
					
					For ($i; 1; Size of array($ids))
						If ($ids{$i}#"selRect")
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
