// ListEvents form method — builds a hierarchical list on load

Case of
	: (FORM Event.code=On Load)
		
		var $list : Integer
		$list:=New list
		
		// Fruits with sublevel
		var $fruits : Integer
		$fruits:=New list
		APPEND TO LIST($fruits; "Apple"; 11)
		APPEND TO LIST($fruits; "Banana"; 12)
		APPEND TO LIST($fruits; "Cherry"; 13)
		APPEND TO LIST($list; "Fruits"; 1; $fruits; False)
		
		// Vegetables with sublevel
		var $vegs : Integer
		$vegs:=New list
		APPEND TO LIST($vegs; "Carrot"; 21)
		APPEND TO LIST($vegs; "Spinach"; 22)
		APPEND TO LIST($vegs; "Broccoli"; 23)
		APPEND TO LIST($list; "Vegetables"; 2; $vegs; False)
		
		// Grains (no sublevel)
		APPEND TO LIST($list; "Grains"; 3)
		
		// Dairy with sublevel
		var $dairy : Integer
		$dairy:=New list
		APPEND TO LIST($dairy; "Milk"; 41)
		APPEND TO LIST($dairy; "Cheese"; 42)
		APPEND TO LIST($list; "Dairy"; 4; $dairy; False)
		
		OBJECT SET LIST BY REFERENCE(*; "EventList"; $list)
		Form.listRef:=$list
		Form.eventLog:=""
		
	: (FORM Event.code=On Unload)
		
		If (Is a list(Form.listRef))
			CLEAR LIST(Form.listRef; *)
		End if
		
End case
