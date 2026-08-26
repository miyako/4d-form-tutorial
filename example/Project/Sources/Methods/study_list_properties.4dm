// study_list_properties
// Creates lists exercising SET LIST ITEM PROPERTIES and SET LIST ITEM PARAMETER
// then saves them to study how lists.json stores each attribute

var $list : Integer

// =============================================
// List 1: "PropertyTests" — SET LIST ITEM PROPERTIES
// Tests: enterable, styles (bold/italic/underline), color
// =============================================
$list:=New list

APPEND TO LIST($list; "Plain item"; 1)
SET LIST ITEM PROPERTIES($list; 1; False; 0)

APPEND TO LIST($list; "Bold item"; 2)
SET LIST ITEM PROPERTIES($list; 2; False; 1)

APPEND TO LIST($list; "Italic item"; 3)
SET LIST ITEM PROPERTIES($list; 3; False; 2)

APPEND TO LIST($list; "Underline item"; 4)
SET LIST ITEM PROPERTIES($list; 4; False; 4)

APPEND TO LIST($list; "Bold+Italic"; 5)
SET LIST ITEM PROPERTIES($list; 5; False; 3)

APPEND TO LIST($list; "Bold+Underline"; 6)
SET LIST ITEM PROPERTIES($list; 6; False; 5)

APPEND TO LIST($list; "All styles"; 7)
SET LIST ITEM PROPERTIES($list; 7; False; 7)

APPEND TO LIST($list; "Red text"; 8)
SET LIST ITEM PROPERTIES($list; 8; False; 0; ""; 0x00FF0000)

APPEND TO LIST($list; "Green text"; 9)
SET LIST ITEM PROPERTIES($list; 9; False; 0; ""; 0x0000FF00)

APPEND TO LIST($list; "Blue bold"; 10)
SET LIST ITEM PROPERTIES($list; 10; False; 1; ""; 0x000000FF)

APPEND TO LIST($list; "Enterable item"; 11)
SET LIST ITEM PROPERTIES($list; 11; True; 0)

APPEND TO LIST($list; "Non-enterable item"; 12)
SET LIST ITEM PROPERTIES($list; 12; False; 0)

SAVE LIST($list; "PropertyTests")
CLEAR LIST($list; *)

// =============================================
// List 2: "ParameterTests" — SET LIST ITEM PARAMETER
// Tests: Additional text, Associated standard action, custom params
// =============================================
$list:=New list

APPEND TO LIST($list; "Item with additional text"; 1)
SET LIST ITEM PARAMETER($list; 1; "4D_additional_text"; "→ extra info")

APPEND TO LIST($list; "Item with custom text param"; 2)
SET LIST ITEM PARAMETER($list; 2; "myCategory"; "electronics")

APPEND TO LIST($list; "Item with custom number param"; 3)
SET LIST ITEM PARAMETER($list; 3; "myPrice"; 29.99)

APPEND TO LIST($list; "Item with custom boolean param"; 4)
SET LIST ITEM PARAMETER($list; 4; "myActive"; True)

APPEND TO LIST($list; "Item with multiple params"; 5)
SET LIST ITEM PARAMETER($list; 5; "myCategory"; "books")
SET LIST ITEM PARAMETER($list; 5; "myPrice"; 14.50)
SET LIST ITEM PARAMETER($list; 5; "myActive"; False)
SET LIST ITEM PARAMETER($list; 5; "4D_additional_text"; "→ multi-param")

APPEND TO LIST($list; "Standard action item"; 6)
SET LIST ITEM PARAMETER($list; 6; "4D_standard_action_name"; "fontSize?value=12pt")

SAVE LIST($list; "ParameterTests")
CLEAR LIST($list; *)

// =============================================
// List 3: "CombinedTests" — both properties AND parameters
// =============================================
$list:=New list

APPEND TO LIST($list; "Bold red with extra text"; 1)
SET LIST ITEM PROPERTIES($list; 1; True; 1; ""; 0x00FF0000)
SET LIST ITEM PARAMETER($list; 1; "4D_additional_text"; "→ details")
SET LIST ITEM PARAMETER($list; 1; "myNote"; "important")

var $sub : Integer
$sub:=New list
APPEND TO LIST($sub; "Child italic green"; 10)
SET LIST ITEM PROPERTIES($sub; 10; False; 2; ""; 0x00008000)
SET LIST ITEM PARAMETER($sub; 10; "myLevel"; "leaf")

APPEND TO LIST($sub; "Child underline blue"; 11)
SET LIST ITEM PROPERTIES($sub; 11; False; 4; ""; 0x000000FF)
SET LIST ITEM PARAMETER($sub; 11; "4D_additional_text"; "→ child info")

APPEND TO LIST($list; "Parent with styled children"; 2; $sub; True)
SET LIST ITEM PROPERTIES($list; 2; False; 1)
SET LIST ITEM PARAMETER($list; 2; "myType"; "category")

SAVE LIST($list; "CombinedTests")
CLEAR LIST($list; *)

QUIT 4D
