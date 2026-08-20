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
var $screenshotPath : Text
$screenshotPath:=$userParams[2]

If ($screenshotPath="")
	return 
End if 

If ($formPage<1)
	$formPage:=1
End if 

var $file : 4D:C1709.File
$file:=File:C1566($screenshotPath)
$file.parent.create()

var $width; $height; $pages : Integer
FORM GET PROPERTIES:C674($formName; $width; $height; $pages)

If ($formPage>$pages)
	$formPage:=$pages
End if 

SET PRINT OPTION:C733(Destination option:K47:7; 3; $file.platformPath)

FORM LOAD:C1103($formName)
$height:=Print form:C5($formName; Form detail:K43:1)
FORM UNLOAD:C1299

If (Application info:C1599.headless)
	LOG EVENT:C667(Into system standard outputs:K38:9; $file.path; Information message:K38:1)
	QUIT 4D:C291
End if 