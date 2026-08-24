//%attributes = {"invisible":true}
var $event : cs.EventObject
$event:=FORM Event

Case of 
	: ($event.code=On Load)
		
		// ST commands require a variable (field or local var), not an expression like Form.xxx.
		// Pattern: assign plain text to $st, call ST commands on $st, assign back to Form.xxx.
		
		var $st : Text
		
		// === PAGE 1: ST SET ATTRIBUTES ===
		
		// Test 1: Bold on "Hello"
		$st:="Hello World"
		ST SET ATTRIBUTES($st; 1; 6; Attribute bold style; 1)
		Form.st_bold:=$st
		
		// Test 2: Italic on "World"
		$st:="Hello World"
		ST SET ATTRIBUTES($st; 7; 12; Attribute italic style; 1)
		Form.st_italic:=$st
		
		// Test 3: Red text color on "Warning"
		$st:="This is a Warning message"
		ST SET ATTRIBUTES($st; 11; 18; Attribute text color; "#FF0000")
		Form.st_color:=$st
		
		// Test 4: Yellow background on "highlighted"
		$st:="This is highlighted text"
		ST SET ATTRIBUTES($st; 9; 20; Attribute background color; "#FFFF00")
		Form.st_bgcolor:=$st
		
		// Test 5: Large font size on "BIG"
		$st:="This is BIG text here"
		ST SET ATTRIBUTES($st; 9; 12; Attribute text size; 24)
		Form.st_size:=$st
		
		// Test 6: Courier font on "monospaced"
		$st:="This is monospaced text"
		ST SET ATTRIBUTES($st; 9; 19; Attribute font name; "Courier New")
		Form.st_font:=$st
		
		// Test 7: Underline
		$st:="This word is underlined here"
		ST SET ATTRIBUTES($st; 14; 24; Attribute underline style; 1)
		Form.st_underline:=$st
		
		// Test 8: Strikethrough
		$st:="This price is $99.99 was wrong"
		ST SET ATTRIBUTES($st; 15; 21; Attribute strikethrough style; 1)
		Form.st_strikethrough:=$st
		
		// Test 9: Combined - bold+red on same range (two calls)
		$st:="Status: ERROR - please fix"
		ST SET ATTRIBUTES($st; 9; 14; Attribute bold style; 1)
		ST SET ATTRIBUTES($st; 9; 14; Attribute text color; "#CC0000")
		Form.st_multi:=$st
		
		// Test 10: Multiple attributes in a single call
		$st:="Important notice for all users"
		ST SET ATTRIBUTES($st; 1; 10; Attribute bold style; 1; Attribute text color; "#0000FF"; Attribute underline style; 1)
		Form.st_multiattr:=$st
		
		// === PAGE 2: ST SET TEXT / ST SET PLAIN TEXT / ST GET PLAIN TEXT ===
		
		// Test 11: ST SET TEXT inserts styled HTML (replaces "World" with green bold text)
		$st:="Hello World"
		ST SET TEXT($st; "<span style=\"color:#009900;font-weight:bold\">Green Bold</span>"; 7; 12)
		Form.st_settext:=$st
		
		// Test 12: ST SET PLAIN TEXT preserves angle brackets as literal text
		$st:="Use tags: here"
		ST SET PLAIN TEXT($st; "<b>not bold</b>"; 11; 15)
		Form.st_setplain:=$st
		
		// Test 13: ST GET PLAIN TEXT strips markup
		$st:="Hello World"
		ST SET ATTRIBUTES($st; 1; 6; Attribute bold style; 1; Attribute text color; "#FF0000")
		Form.st_getplain_result:="raw="+$st+"\nplain="+ST Get plain text($st)
		
		// Test 14: Insert at position (no replacement — startSel=endSel)
		$st:="HelloWorld"
		ST SET PLAIN TEXT($st; " Beautiful "; 6; 6)
		Form.st_insertat:=$st
		
		// Test 15: Replace range 7-12
		$st:="Hello World, goodbye!"
		ST SET PLAIN TEXT($st; "Earth"; 7; 12)
		Form.st_replace:=$st
		
		// === PAGE 3: ST GET ATTRIBUTES / HIGHLIGHT TEXT / Emoji ===
		
		// Test 16: ST GET ATTRIBUTES — read back what was set
		$st:="Hello World"
		ST SET ATTRIBUTES($st; 1; 6; Attribute bold style; 1; Attribute text color; "#FF0000")
		Form.st_getattr_src:=$st
		
		var $bold : Integer
		var $color : Text
		var $fontSize : Integer
		ST GET ATTRIBUTES($st; 1; 6; Attribute bold style; $bold; Attribute text color; $color; Attribute text size; $fontSize)
		Form.st_getattr_report:="bold="+String($bold)+" color="+$color+" size="+String($fontSize)
		
		// Test 17: HIGHLIGHT TEXT — programmatic selection (handled by object method on focus)
		Form.st_highlight:="Hello World, select me!"
		
		// Test 18: Emoji / surrogate pair handling
		$st:="Hi 😀 there"
		// emoji 😀 is U+1F600, a surrogate pair in UTF-16
		// "Hi " = 3 chars (positions 1-4)
		// 😀 = 2 code units (positions 4-6)
		// " there" = 6 chars (positions 6-12)
		// Bold on emoji: range 4-6
		ST SET ATTRIBUTES($st; 4; 6; Attribute bold style; 1; Attribute text size; 20)
		Form.st_emoji:=$st
		
		var $plain : Text
		$plain:=ST Get plain text($st)
		Form.st_emoji_report:="plain='"+$plain+"' length="+String(Length($plain))+" (expect 9 if char-based, 10 if code-unit)"
		
End case 
