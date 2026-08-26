// ListTests form method
// Populates a hierarchical list with a food taxonomy
// Demonstrates SET LIST ITEM ICON and SET LIST ITEM FONT

Case of
	:(FORM Event.code=On Load)
		
		var $list : Integer
		$list:=New list
		
		// --- Create colored circle icons via SVG ---
		var $iconFruit; $iconVeg; $iconGrain; $iconDairy : Picture
		var $svg : Text
		var $svgRef; $el : Text
		
		// Red circle for Fruits
		$svgRef:=DOM Create XML Ref("svg"; "http://www.w3.org/2000/svg")
		DOM SET XML ATTRIBUTE($svgRef; "width"; "16"; "height"; "16"; "viewBox"; "0 0 16 16")
		$el:=DOM Create XML element($svgRef; "circle")
		DOM SET XML ATTRIBUTE($el; "cx"; "8"; "cy"; "8"; "r"; "7"; "fill"; "#E74C3C")
		SVG EXPORT TO PICTURE($svgRef; $iconFruit)
		DOM CLOSE XML($svgRef)
		
		// Green circle for Vegetables
		$svgRef:=DOM Create XML Ref("svg"; "http://www.w3.org/2000/svg")
		DOM SET XML ATTRIBUTE($svgRef; "width"; "16"; "height"; "16"; "viewBox"; "0 0 16 16")
		$el:=DOM Create XML element($svgRef; "circle")
		DOM SET XML ATTRIBUTE($el; "cx"; "8"; "cy"; "8"; "r"; "7"; "fill"; "#27AE60")
		SVG EXPORT TO PICTURE($svgRef; $iconVeg)
		DOM CLOSE XML($svgRef)
		
		// Orange circle for Grains
		$svgRef:=DOM Create XML Ref("svg"; "http://www.w3.org/2000/svg")
		DOM SET XML ATTRIBUTE($svgRef; "width"; "16"; "height"; "16"; "viewBox"; "0 0 16 16")
		$el:=DOM Create XML element($svgRef; "circle")
		DOM SET XML ATTRIBUTE($el; "cx"; "8"; "cy"; "8"; "r"; "7"; "fill"; "#F39C12")
		SVG EXPORT TO PICTURE($svgRef; $iconGrain)
		DOM CLOSE XML($svgRef)
		
		// Blue circle for Dairy
		$svgRef:=DOM Create XML Ref("svg"; "http://www.w3.org/2000/svg")
		DOM SET XML ATTRIBUTE($svgRef; "width"; "16"; "height"; "16"; "viewBox"; "0 0 16 16")
		$el:=DOM Create XML element($svgRef; "circle")
		DOM SET XML ATTRIBUTE($el; "cx"; "8"; "cy"; "8"; "r"; "7"; "fill"; "#3498DB")
		SVG EXPORT TO PICTURE($svgRef; $iconDairy)
		DOM CLOSE XML($svgRef)
		
		// === Fruits ===
		var $fruits : Integer
		$fruits:=New list
		APPEND TO LIST($fruits; "Apple"; 101)
		APPEND TO LIST($fruits; "Banana"; 102)
		APPEND TO LIST($fruits; "Cherry"; 103)
		APPEND TO LIST($fruits; "Mango"; 104)
		
		APPEND TO LIST($list; "Fruits"; 1; $fruits; True)
		SET LIST ITEM ICON($list; 1; $iconFruit)
		SET LIST ITEM FONT($list; 1; "Helvetica Neue")
		
		// === Vegetables ===
		var $vegetables : Integer
		$vegetables:=New list
		
		var $leafy : Integer
		$leafy:=New list
		APPEND TO LIST($leafy; "Spinach"; 211)
		APPEND TO LIST($leafy; "Kale"; 212)
		APPEND TO LIST($leafy; "Lettuce"; 213)
		
		var $roots : Integer
		$roots:=New list
		APPEND TO LIST($roots; "Carrot"; 221)
		APPEND TO LIST($roots; "Potato"; 222)
		APPEND TO LIST($roots; "Beet"; 223)
		
		APPEND TO LIST($vegetables; "Leafy Greens"; 21; $leafy; True)
		APPEND TO LIST($vegetables; "Root Vegetables"; 22; $roots; False)
		
		APPEND TO LIST($list; "Vegetables"; 2; $vegetables; True)
		SET LIST ITEM ICON($list; 2; $iconVeg)
		SET LIST ITEM FONT($list; 2; "Georgia")
		
		// === Grains ===
		var $grains : Integer
		$grains:=New list
		APPEND TO LIST($grains; "Rice"; 301)
		APPEND TO LIST($grains; "Wheat"; 302)
		APPEND TO LIST($grains; "Oats"; 303)
		
		APPEND TO LIST($list; "Grains"; 3; $grains; False)
		SET LIST ITEM ICON($list; 3; $iconGrain)
		SET LIST ITEM FONT($list; 3; "Courier New")
		
		// === Dairy ===
		APPEND TO LIST($list; "Dairy"; 4)
		SET LIST ITEM ICON($list; 4; $iconDairy)
		SET LIST ITEM FONT($list; 4; "Times New Roman")
		
		Form.listRef:=$list
		
	:(FORM Event.code=On Unload)
		
		If (Is a list(Form.listRef))
			CLEAR LIST(Form.listRef; *)
			Form.listRef:=0
		End if
		
End case
