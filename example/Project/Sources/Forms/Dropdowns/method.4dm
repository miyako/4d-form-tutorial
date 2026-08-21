var $event:=FORM Event

Case of 
	: ($event.code=On Load)
		
		// Object-based drop-down list
		Form.dropFruit:=New object
		Form.dropFruit.values:=New collection("Apple"; "Banana"; "Cherry")
		Form.dropFruit.index:=1
		Form.dropFruit.currentValue:="Banana"
		
		Form.dropFruitPlaceholder:=New object
		Form.dropFruitPlaceholder.values:=New collection("Apple"; "Banana"; "Cherry")
		Form.dropFruitPlaceholder.index:=-1
		Form.dropFruitPlaceholder.currentValue:="Select a fruit"
		
		// Array-based drop-down list
		ARRAY TEXT(asColor; 3)
		asColor{1}:="Red"
		asColor{2}:="Green"
		asColor{3}:="Blue"
		
		// Choice list drop-down lists
		Form.dropSaveValue:="Blue"
		Form.dropSaveReference:=3
		
	: ($event.code=On Unload)
		
		CLEAR VARIABLE(asColor)
		
End case 
