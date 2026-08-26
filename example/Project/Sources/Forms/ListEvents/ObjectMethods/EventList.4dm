// EventList object method — logs all list events to Form.eventLog

var $event : Text
var $itemRef : Integer
var $itemText : Text
var $detail : Text
var $itenPos : Integer
var $dropPosition : Integer
var $data : Blob

$event:=String:C10(FORM Event:C1606.code)

// Get selected item info
var $listRef : Integer
$listRef:=OBJECT Get list reference:C1267(*; "EventList")
If (Is a list:C621($listRef))
	$itenPos:=Selected list items:C379($listRef)
	GET LIST ITEM:C378($listRef; $itenPos; $itemRef; $itemText)
	//GET LIST ITEM($listRef; Selected list items($listRef); $itemText; $itemRef)
End if 

Case of 
	: (FORM Event:C1606.code=On Drop:K2:12)
		
		$dropPosition:=Drop position:C608
		GET PASTEBOARD DATA:C401("private.myapp.list.item"; $data)
		var $context
		BLOB TO VARIABLE:C533($data; $context)
		
		// Find source item's current position and preserve its sublist
		var $srcPos : Integer
		var $count : Integer
		var $srcSubList : Integer
		var $srcExpanded : Boolean
		$count:=Count list items:C380($listRef)
		var $i : Integer
		var $tmpRef : Integer
		var $tmpText : Text
		$srcPos:=0
		For ($i; 1; $count)
			GET LIST ITEM:C378($listRef; $i; $tmpRef; $tmpText; $srcSubList; $srcExpanded)
			If ($tmpRef=$context.itemRef)
				$srcPos:=$i
				$i:=$count  // break
			End if
		End for
		
		If ($srcPos=0)
			// Source item not found — bail
		Else
			If ($dropPosition=$srcPos)
				// Dropped on itself — nothing to do
			Else
				If ($dropPosition#-1)
					// Get the ref of the insert-before item
					var $targetRef : Integer
					var $targetText : Text
					If ($dropPosition>$srcPos)
						// Moving down: insert AFTER the drop target (take its place)
						If (($dropPosition+1)>$count)
							$targetRef:=0  // signal to use APPEND
						Else
							GET LIST ITEM:C378($listRef; $dropPosition+1; $targetRef; $targetText)
						End if
					Else
						// Moving up: insert BEFORE the drop target (take its place)
						GET LIST ITEM:C378($listRef; $dropPosition; $targetRef; $targetText)
					End if
				End if
				
				// Delete source (without trailing * so sublist survives in memory)
				DELETE FROM LIST:C624($listRef; $context.itemRef)
				
				If (($dropPosition=-1) | ($targetRef=0))
					// Dropped after last item (or target was last)
					APPEND TO LIST:C376($listRef; $context.itemText; $context.itemRef)
				Else
					// Insert before the target item (by ref)
					INSERT IN LIST:C625($listRef; $targetRef; $context.itemText; $context.itemRef)
				End if
				
				// Re-attach sublist if the source had children
				If (Is a list:C621($srcSubList))
					SET LIST ITEM:C385($listRef; $context.itemRef; $context.itemText; $context.itemRef; $srcSubList; $srcExpanded)
				End if
			End if
			
			SELECT LIST ITEMS BY REFERENCE:C630($listRef; $context.itemRef)
			$detail:="ON DROP → moved \""+$context.itemText+"\" from pos "+String:C10($srcPos)+" to drop "+String:C10($dropPosition)
		End if
	: (FORM Event:C1606.code=On Drag Over:K2:13)
		
		$dropPosition:=Drop position:C608
		
		If (Pasteboard data size:C400("private.myapp.list.item")>0)
			$0:=0
		Else 
			$0:=-1
		End if 
		
		$detail:="ON BEGIN DRAG OVER → position: "+String:C10($dropPosition)
		
	: (FORM Event:C1606.code=On Begin Drag Over:K2:44)
		
		$context:={}
		$context.objectName:=FORM Event:C1606.objectName
		$context.itemText:=$itemText
		$context.itemRef:=$itemRef
		VARIABLE TO BLOB:C532($context; $data)
		APPEND DATA TO PASTEBOARD:C403("private.myapp.list.item"; $data)
		$detail:="ON BEGIN DRAG OVER → item: \""+$itemText+"\" (ref: "+String:C10($itemRef)+")"
		
	: (FORM Event:C1606.code=On Delete Action:K2:56)
		$detail:="ON DELETE ACTION → item: \""+$itemText+"\" (ref: "+String:C10($itemRef)+")"
		
	: (FORM Event:C1606.code=On After Edit:K2:43)
		$detail:="ON AFTER EDIT → item: \""+Get edited text:C655+"\" (ref: "+String:C10($itemRef)+")"
		
	: (FORM Event:C1606.code=On Data Change:K2:15)
		$detail:="ON DATA CHANGE → item: \""+$itemText+"\" (ref: "+String:C10($itemRef)+")"
		
	: (FORM Event:C1606.code=On Selection Change:K2:29)
		$detail:="ON SELECTION CHANGE → item: \""+$itemText+"\" (ref: "+String:C10($itemRef)+")"
		
	: (FORM Event:C1606.code=On Expand:K2:41)
		$detail:="ON EXPAND → item: \""+$itemText+"\" (ref: "+String:C10($itemRef)+")"
		
	: (FORM Event:C1606.code=On Collapse:K2:42)
		$detail:="ON COLLAPSE → item: \""+$itemText+"\" (ref: "+String:C10($itemRef)+")"
		
	: (FORM Event:C1606.code=On Clicked:K2:4)
		$detail:="ON CLICKED → item: \""+$itemText+"\" (ref: "+String:C10($itemRef)+")"
		
	: (FORM Event:C1606.code=On Double Clicked:K2:5)
		$detail:="ON DOUBLE CLICKED → item: \""+$itemText+"\" (ref: "+String:C10($itemRef)+")"
		
End case 

// Prepend to log (newest first)
If ($detail#"")
	If (Form:C1466.eventLog#"")
		Form:C1466.eventLog:=$detail+"\r"+Form:C1466.eventLog
	Else 
		Form:C1466.eventLog:=$detail
	End if 
	OBJECT SET VALUE:C1742("EventLog"; Form:C1466.eventLog)
End if 
