// ListFromEditor form method
// Loads a pre-defined list from lists.json via Load list

Case of
	:(FORM Event.code=On Load)
		
		Form.listRef:=Load list("FoodTaxonomy")
		
	:(FORM Event.code=On Unload)
		
		If (Is a list(Form.listRef))
			CLEAR LIST(Form.listRef; *)
			Form.listRef:=0
		End if
		
End case
