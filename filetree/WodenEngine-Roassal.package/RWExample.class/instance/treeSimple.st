trees
treeSimple
	"
	self new treeSimple
	"
	| view  objects associations elements assocWithElements|
	view := RWView new.
	objects := { 1 . 2 . 3 . 4 }.
	associations := { 1 -> 2 . 2 -> 3 . 2 -> 4 }.
	
	elements := objects collect: [ :o | RWCube blue elementOn:  o ].
"	elements do: [ :e | e addInteraction: RWPopup ]."
	view addAll: elements.
	
	assocWithElements := associations collect: [ :a | (view elementFromModel: a key) -> (view elementFromModel: a value)].
	view addAll: (RWEdge linesFor: assocWithElements).
	
	RWGridTreeLayout on: view elements.
	view addInteraction: RWMouseKeyControl.
"	view openWithOverlay."
	view open