test layout
testTreeLayout
	| a b c d elements assocs edges |
	
	"A simple tree."
	a := RWCube element.
	b := RWCube element.
	c := RWCube element.
	d := RWCube element.
	
	elements := { a . b . c . d }.
	assocs := { a -> b .  b -> c . b -> d }.
	edges := RWEdge linesFor: assocs.
	
	"Check the layout."
	RWGridTreeLayout on: elements edges: edges.
	self assert: (c position y closeTo: d position y).
	self assert: (b position y > c position y).
	self assert: (a position y > b position y).