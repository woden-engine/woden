tests
testBasic
 
	| view e1 e2 edge |
	view := RWView new.
	e1 := RWCube red element.
	e2 := RWCube green element.
	
	e2 translateByX: 2.0.
	
	edge := RWLine blue elementFrom: e1 to: e2.
	
	view add: e1; add: e2; add: edge.
	"Lights?"
	self assert: view numberOfElements = 3