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

var $screenshot : Picture
Case of 
	: (False:C215)
		FORM LOAD:C1103($formName)
		FORM GOTO PAGE:C247($formPage)
		FORM SCREENSHOT:C940($screenshot)
		FORM UNLOAD:C1299
	: (True:C214)
		FORM SCREENSHOT:C940($formName; $screenshot; $formPage)
End case 

WRITE PICTURE FILE:C680($file.platformPath; $screenshot)

If (Application info:C1599.headless)
	LOG EVENT:C667(Into system standard outputs:K38:9; $file.path; Information message:K38:1)
	QUIT 4D:C291
End if 