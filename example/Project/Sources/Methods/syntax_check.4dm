//%attributes = {"invisible":true}
// CLI endpoint: runs syntax check (not full compilation) and writes errors to JSON.
// Usage: tool4d --dataless --project ... --startup-method syntax_check
// Output: syntax_errors.json in the database folder (next to Project/)

var $options : Object
$options:=New object
$options.targets:=New collection  // empty = syntax check only

var $result : Object
$result:=Compile project($options)

var $json : Text
$json:=JSON Stringify($result; *)

var $blob : Blob
CONVERT FROM TEXT($json; "utf-8"; $blob)
var $path : Text
$path:=Get 4D folder(Database folder)+"syntax_errors.json"
BLOB TO DOCUMENT($path; $blob)

QUIT 4D
