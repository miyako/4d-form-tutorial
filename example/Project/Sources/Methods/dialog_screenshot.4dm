//%attributes = {"invisible":true}
// CLI endpoint: opens a form with DIALOG, takes a runtime screenshot, saves to disk, quits.
// Usage: --startup-method dialog_screenshot --user-param "FormName:Page:/RESOURCES/path.png"
// Requires 4D (not tool4d) because it uses DIALOG.

var $userParamValue : Text
Get database parameter(User param value; $userParamValue)

var $params : Collection
$params:=Split string($userParamValue; ":")

If ($params.length<3)
	QUIT 4D
	return 
End if 

var $formName : Text
$formName:=$params[0]

var $formPage : Integer
$formPage:=Num($params[1])
If ($formPage<1)
	$formPage:=1
End if 

var $screenshotPath : Text
$screenshotPath:=$params[2]

var $form : Object
$form:={}
$form.__page:=$formPage
$form.__screenshotPath:=$screenshotPath

var $window : Integer
$window:=Open form window($formName)
DIALOG($formName; $form; *)

CALL FORM($window; Formula(goto_page_then_screenshot))
