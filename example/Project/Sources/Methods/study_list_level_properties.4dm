// study_list_level_properties
// Tests SET LIST PROPERTIES (list-level, not per-item)
// Parameters: appearance(deprecated), icon(deprecated), lineHeight, doubleClick, multiSelections, editable

var $list : Integer

// List with lineHeight set
$list:=New list
APPEND TO LIST($list; "Item A"; 1)
APPEND TO LIST($list; "Item B"; 2)
APPEND TO LIST($list; "Item C"; 3)
SET LIST PROPERTIES($list; 0; 0; 30)
SAVE LIST($list; "LineHeight30")
CLEAR LIST($list; *)

// List with doubleClick disabled
$list:=New list
APPEND TO LIST($list; "Parent"; 1)
var $sub : Integer
$sub:=New list
APPEND TO LIST($sub; "Child 1"; 10)
APPEND TO LIST($sub; "Child 2"; 11)
APPEND TO LIST($list; "Parent"; 1; $sub; True)
SET LIST PROPERTIES($list; 0; 0; 0; 1)
SAVE LIST($list; "NoDoubleClick")
CLEAR LIST($list; *)

// List with multiSelections enabled
$list:=New list
APPEND TO LIST($list; "Select me 1"; 1)
APPEND TO LIST($list; "Select me 2"; 2)
APPEND TO LIST($list; "Select me 3"; 3)
SET LIST PROPERTIES($list; 0; 0; 0; 0; 1)
SAVE LIST($list; "MultiSelect")
CLEAR LIST($list; *)

// List with editable=0 (not editable as choice list)
$list:=New list
APPEND TO LIST($list; "Read-only 1"; 1)
APPEND TO LIST($list; "Read-only 2"; 2)
SET LIST PROPERTIES($list; 0; 0; 0; 0; 0; 0)
SAVE LIST($list; "NotEditableChoiceList")
CLEAR LIST($list; *)

// List with all non-default options combined
$list:=New list
APPEND TO LIST($list; "All options"; 1)
APPEND TO LIST($list; "Combined"; 2)
var $sub2 : Integer
$sub2:=New list
APPEND TO LIST($sub2; "Sub item"; 10)
APPEND TO LIST($list; "Parent node"; 3; $sub2; True)
SET LIST PROPERTIES($list; 0; 0; 24; 1; 1; 0)
SAVE LIST($list; "AllListProps")
CLEAR LIST($list; *)

QUIT 4D
