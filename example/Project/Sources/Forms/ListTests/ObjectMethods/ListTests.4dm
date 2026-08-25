// ListTests form method
// Populates a hierarchical list with a food taxonomy

Case of 
	: (FORM Event:C1606.code=On Load:K2:1)
		
		var $list : Integer
		$list:=New list:C375
		
		// === Fruits ===
		var $fruits : Integer
		$fruits:=New list:C375
		APPEND TO LIST:C376($fruits; "Apple"; 101)
		APPEND TO LIST:C376($fruits; "Banana"; 102)
		APPEND TO LIST:C376($fruits; "Cherry"; 103)
		APPEND TO LIST:C376($fruits; "Mango"; 104)
		
		APPEND TO LIST:C376($list; "Fruits"; 1; $fruits; True:C214)
		
		// === Vegetables ===
		var $vegetables : Integer
		$vegetables:=New list:C375
		
		// Leafy greens (sub-sublist)
		var $leafy : Integer
		$leafy:=New list:C375
		APPEND TO LIST:C376($leafy; "Spinach"; 211)
		APPEND TO LIST:C376($leafy; "Kale"; 212)
		APPEND TO LIST:C376($leafy; "Lettuce"; 213)
		
		// Root vegetables (sub-sublist)
		var $roots : Integer
		$roots:=New list:C375
		APPEND TO LIST:C376($roots; "Carrot"; 221)
		APPEND TO LIST:C376($roots; "Potato"; 222)
		APPEND TO LIST:C376($roots; "Beet"; 223)
		
		APPEND TO LIST:C376($vegetables; "Leafy Greens"; 21; $leafy; True:C214)
		APPEND TO LIST:C376($vegetables; "Root Vegetables"; 22; $roots; False:C215)
		
		APPEND TO LIST:C376($list; "Vegetables"; 2; $vegetables; True:C214)
		
		// === Grains ===
		var $grains : Integer
		$grains:=New list:C375
		APPEND TO LIST:C376($grains; "Rice"; 301)
		APPEND TO LIST:C376($grains; "Wheat"; 302)
		APPEND TO LIST:C376($grains; "Oats"; 303)
		
		APPEND TO LIST:C376($list; "Grains"; 3; $grains; False:C215)
		
		// === Dairy ===
		APPEND TO LIST:C376($list; "Dairy"; 4)
		
		Form:C1466.listRef:=$list
		
	: (FORM Event:C1606.code=On Unload:K2:2)
		
		If (Is a list:C621(Form:C1466.listRef))
			CLEAR LIST:C377(Form:C1466.listRef; *)
			Form:C1466.listRef:=0
		End if 
		
End case 
