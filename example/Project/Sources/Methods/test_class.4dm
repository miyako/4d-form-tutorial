//%attributes = {}
var $window : Integer
$window:=Open form window:C675("MyFirstProjectForm")
var $form : cs:C1710.MyFormController
$form:=cs:C1710.MyFormController.new()
DIALOG:C40("MyFirstProjectForm"; $form)
ALERT:C41("You clicked "+String:C10($form.count)+" times!")