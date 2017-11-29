tests
testWithControlPoint
	| e |
	e := RWEdge new controlPoints: { nil . nil }.
	self assert: (e controlPoint: 1) = nil.
	e controlPoint: 1 put: 2.
	self assert: (e controlPoint: 1) = 2.