tests
testLinesFor
	| a b c d assocs edges |
	a := RWCube red element.
	b := RWCube green element.
	c := RWCube blue element.
	d := RWCube yellow element.
	assocs := { a -> b . c -> d . b -> c }.
	edges := RWEdge linesFor: assocs.
	self assert: edges size = 3.
	self assert: edges first from == a.
	self assert: edges first to == b.
	self assert: edges second from == c.
	self assert: edges second to == d.
	self assert: edges third from == b.
	self assert: edges third to == c.