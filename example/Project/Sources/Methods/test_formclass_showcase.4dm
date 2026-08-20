//%attributes = {}
var $window : Integer
$window:=Open form window("FormClassShowcase")
var $form : cs.FormClassShowcaseController
$form:=cs.FormClassShowcaseController.new()
DIALOG("FormClassShowcase"; $form)
ALERT("You clicked "+String($form.clickCount)+" times!")
