//%attributes = {"invisible":true}
var $event : cs.EventObject
$event:=FORM Event

Case of 
	: ($event.code=On Load)
		
		// === PAGE 1: ST SET ATTRIBUTES ===
		
		// Test 1: Bold on "Hello"
		Form.st_bold:="Hello World"
		ST SET ATTRIBUTES(Form.st_bold; 1; 6; Attribute bold style; 1)
		
		// Test 2: Italic on "World"
		Form.st_italic:="Hello World"
		ST SET ATTRIBUTES(Form.st_italic; 7; 12; Attribute italic style; 1)
		
		// Test 3: Red text color on "Warning"
		Form.st_color:="This is a Warning message"
		ST SET ATTRIBUTES(Form.st_color; 11; 18; Attribute text color; "#FF0000")
		
		// Test 4: Yellow background on "highlighted"
		Form.st_bgcolor:="This is highlighted text"
		ST SET ATTRIBUTES(Form.st_bgcolor; 9; 20; Attribute background color; "#FFFF00")
		
		// Test 5: Large font size on "BIG"
		Form.st_size:="This is BIG text here"
		ST SET ATTRIBUTES(Form.st_size; 9; 12; Attribute text size; 24)
		
		// Test 6: Courier font on "monospaced"
		Form.st_font:="This is monospaced text"
		ST SET ATTRIBUTES(Form.st_font; 9; 19; Attribute font name; "Courier New")
		
		// Test 7: Underline
		Form.st_underline:="This word is underlined here"
		ST SET ATTRIBUTES(Form.st_underline; 14; 24; Attribute underline style; 1)
		
		// Test 8: Strikethrough
		Form.st_strikethrough:="This price is $99.99 was wrong"
		ST SET ATTRIBUTES(Form.st_strikethrough; 15; 21; Attribute strikethrough style; 1)
		
		// Test 9: Combined - bold+red on same range
		Form.st_multi:="Status: ERROR - please fix"
		ST SET ATTRIBUTES(Form.st_multi; 9; 14; Attribute bold style; 1)
		ST SET ATTRIBUTES(Form.st_multi; 9; 14; Attribute text color; "#CC0000")
		
		// Test 10: Multiple attributes in a single call
		Form.st_multiattr:="Important notice for all users"
		ST SET ATTRIBUTES(Form.st_multiattr; 1; 10; Attribute bold style; 1; Attribute text color; "#0000FF"; Attribute underline style; 1)
		
		// === PAGE 2: ST SET TEXT / ST SET PLAIN TEXT / ST GET PLAIN TEXT ===
		
		// Test 11: ST SET TEXT inserts styled HTML
		Form.st_settext:="Hello World"
		ST SET TEXT(Form.st_settext; "<span style=\"color:#009900;font-weight:bold\">Green Bold</span>"; 7; 12)
		
		// Test 12: ST SET PLAIN TEXT preserves angle brackets as literal text
		Form.st_setplain:="Use tags: here"
		ST SET PLAIN TEXT(Form.st_setplain; "<b>not bold</b>"; 11; 15)
		
		// Test 13: ST GET PLAIN TEXT strips markup
		var $styledSource : Text
		$styledSource:="Hello World"
		ST SET ATTRIBUTES($styledSource; 1; 6; Attribute bold style; 1; Attribute text color; "#FF0000")
		Form.st_getplain_result:="raw="+$styledSource+"\nplain="+ST Get plain text($styledSource)
		
		// Test 14: Insert at position (no replacement)
		Form.st_insertat:="HelloWorld"
		ST SET PLAIN TEXT(Form.st_insertat; " Beautiful "; 6; 6)
		
		// Test 15: Replace range 7-12
		Form.st_replace:="Hello World, goodbye!"
		ST SET PLAIN TEXT(Form.st_replace; "Earth"; 7; 12)
		
		// === PAGE 3: ST GET ATTRIBUTES / HIGHLIGHT TEXT / Emoji ===
		
		// Test 16: ST GET ATTRIBUTES — read back what was set
		Form.st_getattr_src:="Hello World"
		ST SET ATTRIBUTES(Form.st_getattr_src; 1; 6; Attribute bold style; 1; Attribute text color; "#FF0000")
		
		var $bold : Integer
		var $color : Text
		var $fontSize : Integer
		ST GET ATTRIBUTES(Form.st_getattr_src; 1; 6; Attribute bold style; $bold; Attribute text color; $color; Attribute text size; $fontSize)
		Form.st_getattr_report:="bold="+String($bold)+" color="+$color+" size="+String($fontSize)
		
		// Test 17: HIGHLIGHT TEXT — programmatic selection
		Form.st_highlight:="Hello World, select me!"
		
		// Test 18: Emoji / surrogate pair handling
		Form.st_emoji:="Hi 😀 there"
		// emoji 😀 is U+1F600, a surrogate pair in UTF-16
		// "Hi " = 3 chars (positions 1-4)
		// 😀 = 2 code units (positions 4-6)
		// " there" = 6 chars (positions 6-12)
		// Bold on emoji: range 4-6
		ST SET ATTRIBUTES(Form.st_emoji; 4; 6; Attribute bold style; 1; Attribute text size; 20)
		
		var $plain : Text
		$plain:=ST Get plain text(Form.st_emoji)
		Form.st_emoji_report:="plain='"+$plain+"' length="+String(Length($plain))+" (expect 9 if char-based, 10 if code-unit)"
		
End case 
