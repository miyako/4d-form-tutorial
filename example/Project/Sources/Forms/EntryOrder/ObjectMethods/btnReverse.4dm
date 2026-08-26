// Reverse the entry order of R1-R4
ARRAY TEXT($order; 4)
$order{1}:="R4"
$order{2}:="R3"
$order{3}:="R2"
$order{4}:="R1"
FORM SET ENTRY ORDER($order)
Form.status:="Entry order reversed: R4→R3→R2→R1"
