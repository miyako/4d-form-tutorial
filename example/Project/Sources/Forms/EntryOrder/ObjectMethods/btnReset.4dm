// Reset entry order to default (R1-R4)
ARRAY TEXT($order; 4)
$order{1}:="R1"
$order{2}:="R2"
$order{3}:="R3"
$order{4}:="R4"
FORM SET ENTRY ORDER($order)
Form.status:="Entry order reset: R1→R2→R3→R4"
