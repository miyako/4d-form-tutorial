// ListTests form method
// Populates a hierarchical list with a food taxonomy

Case of
	:(FORM Event.code=On Load)
		
		var $list : Integer
		$list:=New list
		
		// === Fruits ===
		var $fruits : Integer
		$fruits:=New list
		APPEND TO LIST($fruits; "Apple"; 101)
		APPEND TO LIST($fruits; "Banana"; 102)
		APPEND TO LIST($fruits; "Cherry"; 103)
		APPEND TO LIST($fruits; "Mango"; 104)
		
		APPEND TO LIST($list; "Fruits"; 1; $fruits; True)
		
		// === Vegetables ===
		var $vegetables : Integer
		$vegetables:=New list
		
		// Leafy greens (sub-sublist)
		var $leafy : Integer
		$leafy:=New list
		APPEND TO LIST($leafy; "Spinach"; 211)
		APPEND TO LIST($leafy; "Kale"; 212)
		APPEND TO LIST($leafy; "Lettuce"; 213)
		
		// Root vegetables (sub-sublist)
		var $roots : Integer
		$roots:=New list
		APPEND TO LIST($roots; "Carrot"; 221)
		APPEND TO LIST($roots; "Potato"; 222)
		APPEND TO LIST($roots; "Beet"; 223)
		
		APPEND TO LIST($vegetables; "Leafy Greens"; 21; $leafy; True)
		APPEND TO LIST($vegetables; "Root Vegetables"; 22; $roots; False)
		
		APPEND TO LIST($list; "Vegetables"; 2; $vegetables; True)
		
		// === Grains ===
		var $grains : Integer
		$grains:=New list
		APPEND TO LIST($grains; "Rice"; 301)
		APPEND TO LIST($grains; "Wheat"; 302)
		APPEND TO LIST($grains; "Oats"; 303)
		
		APPEND TO LIST($list; "Grains"; 3; $grains; False)
		
		// === Dairy ===
		APPEND TO LIST($list; "Dairy"; 4)
		
		Form.listRef:=$list
		
	:(FORM Event.code=On Unload)
		
		If (Form.listRef#0)
			CLEAR LIST(Form.listRef; *)
			Form.listRef:=0
		End if
		
End case
