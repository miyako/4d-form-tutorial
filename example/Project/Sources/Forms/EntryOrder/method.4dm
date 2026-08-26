// EntryOrder - Form method
// Tracks focus changes and manages page navigation

var $event : Object
$event:=FORM Event

Case of
	: ($event.code=On Load)
		Form.status:="Page 1: Default entry order (Tab through A→B→C→D→E)"
		
	: ($event.code=On Page Change)
		GOTO OBJECT(*; "")
		
		Case of
			: (FORM Get current page=1)
				Form.status:="Page 1: Default order = JSON declaration order. Tab: A→B→C→D→E"
			: (FORM Get current page=2)
				Form.status:="Page 2: Custom entryOrder reverses tab: Z→X→Y"
			: (FORM Get current page=3)
				Form.status:="Page 3: Subset — only First and Third are in entryOrder. Middle is skipped."
			: (FORM Get current page=4)
				Form.status:="Page 4: Use FORM SET ENTRY ORDER at runtime. Try Reverse/Reset."
			: (FORM Get current page=5)
				Form.status:="Page 5: GOTO OBJECT jumps focus. Clear Focus removes it."
		End case
		
	: ($event.code=On Getting Focus)
		Form.status:="Focused: "+$event.objectName
		
End case
