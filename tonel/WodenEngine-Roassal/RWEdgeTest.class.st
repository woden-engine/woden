Class {
	#name : #RWEdgeTest,
	#superclass : #TestCase,
	#category : 'WodenEngine-Roassal-Tests'
}

{ #category : #tests }
RWEdgeTest >> testBasic [
 
	| view e1 e2 edge |
	view := RWView new.
	e1 := RWCube red element.
	e2 := RWCube green element.
	
	e2 translateByX: 2.0.
	
	edge := RWLine blue elementFrom: e1 to: e2.
	
	view add: e1; add: e2; add: edge.
	"Lights?"
	self assert: view numberOfElements = 3
]

{ #category : #tests }
RWEdgeTest >> testLinesFor [
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
]

{ #category : #tests }
RWEdgeTest >> testNotControlPoint [
	| e |
	e := RWEdge new.
	self should: [ e controlPoint: 1 ] raise: Error.
]

{ #category : #tests }
RWEdgeTest >> testWithControlPoint [
	| e |
	e := RWEdge new controlPoints: { nil . nil }.
	self assert: (e controlPoint: 1) = nil.
	e controlPoint: 1 put: 2.
	self assert: (e controlPoint: 1) = 2.
]
