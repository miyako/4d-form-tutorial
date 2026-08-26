// SVG Draw Tool - Canvas object method
// Handles On Clicked/On Double Clicked: starts draw or selection depending on active tool

var $event : Object
var $pic : Picture
$event:=FORM Event

Case of
	: ($event.code=On Clicked)
		// Record the starting point
		Form.startX:=String(MouseX)
		Form.startY:=String(MouseY)
		
		Case of
			: (Form.tool="line")
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
				
				SVG EXPORT TO PICTURE(Form.dom; $pic)
				Form.SVG:=$pic
				DOM REMOVE XML ELEMENT($line)
				
			: (Form.tool="rect")
				// RECT TOOL: create a temporary rect
				var $r : Text
				$r:=DOM Create XML element(Form.dom; "rect")
				DOM SET XML ATTRIBUTE($r; \
					"id"; "currentRect"; \
					"x"; Form.startX; \
					"y"; Form.startY; \
					"width"; "0"; \
					"height"; "0"; \
					"fill"; "none"; \
					"stroke"; "black"; \
					"stroke-width"; "2")
				
				SVG EXPORT TO PICTURE(Form.dom; $pic)
				Form.SVG:=$pic
				DOM REMOVE XML ELEMENT($r)
				
			: (Form.tool="ellipse")
				// ELLIPSE TOOL: create a temporary ellipse
				var $e : Text
				$e:=DOM Create XML element(Form.dom; "ellipse")
				DOM SET XML ATTRIBUTE($e; \
					"id"; "currentEllipse"; \
					"cx"; Form.startX; \
					"cy"; Form.startY; \
					"rx"; "0"; \
					"ry"; "0"; \
					"fill"; "none"; \
					"stroke"; "black"; \
					"stroke-width"; "2")
				
				SVG EXPORT TO PICTURE(Form.dom; $pic)
				Form.SVG:=$pic
				DOM REMOVE XML ELEMENT($e)
				
			: (Form.tool="polyline")
				// POLYLINE TOOL: add a point on each click
				If (Form.polyPoints=Null)
					Form.polyPoints:=Form.startX+","+Form.startY
					
					var $pl : Text
					$pl:=DOM Create XML element(Form.dom; "polyline")
					DOM SET XML ATTRIBUTE($pl; \
						"id"; "currentPolyline"; \
						"points"; Form.polyPoints; \
						"fill"; "none"; \
						"stroke"; "black"; \
						"stroke-width"; "2")
					
					SVG EXPORT TO PICTURE(Form.dom; $pic)
					Form.SVG:=$pic
					DOM REMOVE XML ELEMENT($pl)
				Else
					Form.polyPoints:=Form.polyPoints+" "+Form.startX+","+Form.startY
					SVG SET ATTRIBUTE(*; "canvas"; "currentPolyline"; "points"; Form.polyPoints)
				End if
				
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
					"fill"; "blue"; \
					"fill-opacity"; "0.1"; \
					"stroke"; "blue"; \
					"stroke-width"; "1"; \
					"stroke-dasharray"; "4,4")
				
				SVG EXPORT TO PICTURE(Form.dom; $pic)
				Form.SVG:=$pic
				DOM REMOVE XML ELEMENT($rect)
		End case
		
		// Start timer for continuous mouse tracking (except polyline which tracks per-click)
		If (Form.tool#"polyline")
			SET TIMER(-1)
		End if
		
	: ($event.code=On Double Clicked)
		// POLYLINE TOOL: double-click finishes the polyline
		If (Form.tool="polyline")
			If (Form.polyPoints#Null)
				Form.lineCount:=Form.lineCount+1
				var $plFinal : Text
				$plFinal:=DOM Create XML element(Form.dom; "polyline")
				DOM SET XML ATTRIBUTE($plFinal; \
					"id"; "polyline"+String(Form.lineCount); \
					"points"; Form.polyPoints; \
					"fill"; "none"; \
					"stroke"; "black"; \
					"stroke-width"; "2")
				
				Form.polyPoints:=Null
				SVG EXPORT TO PICTURE(Form.dom; $pic)
				Form.SVG:=$pic
			End if
		End if
		
End case
