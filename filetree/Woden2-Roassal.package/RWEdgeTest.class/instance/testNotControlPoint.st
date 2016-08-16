tests
testNotControlPoint
	| e |
	e := RWEdge new.
	self should: [ e controlPoint: 1 ] raise: Error.