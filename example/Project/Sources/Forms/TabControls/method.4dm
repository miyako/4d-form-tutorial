var $event:=FORM Event

Case of 
	: ($event.code=On Load)
		
		// Object-based tab control (recommended)
		Form.tabObj:=New object
		Form.tabObj.values:=New collection("Page 1"; "Page 2"; "Page 3")
		Form.tabObj.index:=0
		
		// Array-based tab control
		ARRAY TEXT(arrPages; 3)
		arrPages{1}:="Page 1"
		arrPages{2}:="Page 2"
		arrPages{3}:="Page 3"
		arrPages:=1
		
		// Array-based tab control, manually navigated (no gotoPage action)
		ARRAY TEXT(arrManual; 3)
		arrManual{1}:="Page 1"
		arrManual{2}:="Page 2"
		arrManual{3}:="Page 3"
		arrManual:=1
		
		// Hierarchical list reference (icons would be set with
		// Hierarchical List theme commands: New list/Load list, APPEND TO LIST,
		// SET LIST ITEM ICON); left at 0 here since no icon assets are attached
		Form.tabHierarchical:=0
		
	: ($event.code=On Clicked)
		
		If ($event.objectName="tabManual")
			FORM GOTO PAGE(arrManual)
		End if 
		
	: ($event.code=On Unload)
		
		CLEAR VARIABLE(arrPages)
		CLEAR VARIABLE(arrManual)
		
End case
