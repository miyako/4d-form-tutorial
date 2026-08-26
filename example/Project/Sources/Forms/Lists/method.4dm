// Lists form method
// Demonstrates 3 ways to populate a hierarchical list:
// List1: static "list" property in JSON (design-time)
// List2: OBJECT SET LIST BY NAME (references a named list in lists.json)
// List3: OBJECT SET LIST BY REFERENCE (programmatic ListRef)

Case of
	: (FORM Event.code=On Load)
		
		// --- List2: set by name (references "FoodTaxonomy" from lists.json) ---
		OBJECT SET LIST BY NAME(*; "List2"; "FoodTaxonomy")
		
		// --- List3: set by reference (build programmatically) ---
		var $list : Integer
		$list:=New list
		APPEND TO LIST($list; "Mercury"; 1)
		APPEND TO LIST($list; "Venus"; 2)
		APPEND TO LIST($list; "Earth"; 3)
		APPEND TO LIST($list; "Mars"; 4)
		
		var $inner : Integer
		$inner:=New list
		APPEND TO LIST($inner; "Jupiter"; 5)
		APPEND TO LIST($inner; "Saturn"; 6)
		APPEND TO LIST($inner; "Uranus"; 7)
		APPEND TO LIST($inner; "Neptune"; 8)
		APPEND TO LIST($list; "Outer Planets"; 9; $inner; True)
		
		OBJECT SET LIST BY REFERENCE(*; "List3"; $list)
		Form.list3Ref:=$list
		
	: (FORM Event.code=On Unload)
		
		If (Form.list3Ref#Null)
			If (Is a list(Form.list3Ref))
				CLEAR LIST(Form.list3Ref; *)
			End if
		End if
		
End case

