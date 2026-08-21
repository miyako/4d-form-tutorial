var $event:=FORM Event

Case of 
	: ($event.code=On Load)
		
		// Object-based combo box
		Form.comboFruit:=New object
		Form.comboFruit.values:=New collection("Apple"; "Banana"; "Cherry")
		Form.comboFruit.currentValue:="Banana"
		
		// Array-based combo box
		ARRAY TEXT(asFruit; 3)
		asFruit{1}:="Apple"
		asFruit{2}:="Banana"
		asFruit{3}:="Cherry"
		
		// Choice list combo boxes
		Form.comboPlain:="Red"
		Form.comboAutoIns:="Red"
		Form.comboExcluded:="Red"
		Form.comboRequired:="Red"
		
	: ($event.code=On Unload)
		
		CLEAR VARIABLE(asFruit)
		
End case
