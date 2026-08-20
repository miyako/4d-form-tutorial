//%attributes = {}
var $window : Integer
$window:=Open form window:C675("FormClassShowcase")
var $form : cs:C1710.FormClassShowcaseController
$form:=cs:C1710.FormClassShowcaseController.new()
DIALOG:C40("FormClassShowcase"; $form)
ALERT:C41("You clicked "+String:C10($form.clickCount)+" times!")
