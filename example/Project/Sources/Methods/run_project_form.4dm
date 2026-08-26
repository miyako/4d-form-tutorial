//%attributes = {"invisible":true}
var $userParamValue : Text
var $paramValue : Integer
$paramValue:=Get database parameter:C643(User param value:K37:94; $userParamValue)

var $userParams : Collection
$userParams:=Split string:C1554($userParamValue; ":")

If ($userParams.length<3)
	return 
End if 

var $formName : Text
$formName:=$userParams[0]
var $formPage : Integer
$formPage:=Num:C11($userParams[1])
var $formObjectPath : Text
$formObjectPath:=$userParams[2]

If ($formObjectPath="")
	return 
End if 

If ($formPage<1)
	$formPage:=1
End if 

var $file : 4D:C1709.File
$file:=File:C1566($formObjectPath)
$file.parent.create()

var $width; $height; $pages : Integer
FORM GET PROPERTIES:C674($formName; $width; $height; $pages)

If ($formPage>$pages)
	$formPage:=$pages
End if 

var $form : Object
$form:={}

var $window : Integer
$window:=Open form window:C675($formName)
DIALOG:C40($formName; $form; *)
CALL FORM:C1391($window; Formula:C1597(ACCEPT:C269))

$file.setText(JSON Stringify:C1217($form; *))

If (Application info:C1599.headless)
	LOG EVENT:C667(Into system standard outputs:K38:9; $file.path; Information message:K38:1)
End if 

QUIT 4D:C291