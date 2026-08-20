//%attributes = {}
var $window : Integer
$window:=Open form window:C675("Checkboxes")
var $form : cs:C1710.MyFormController
$form:=cs:C1710.MyFormController.new()
$form.cb1:=0
$form.cb2:=2
$form.cb3:=1
DIALOG:C40("Checkboxes"; $form)