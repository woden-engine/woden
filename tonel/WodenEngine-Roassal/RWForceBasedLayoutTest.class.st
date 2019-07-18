"
I a m basic test for this layout with edge builder
"
Class {
	#name : #RWForceBasedLayoutTest,
	#superclass : #TestCase,
	#category : #'WodenEngine-Roassal-Tests'
}

{ #category : #'as yet unclassified' }
RWForceBasedLayoutTest >> testBasic [ 
	| v boxes |
	v := RWView new.
	boxes := RWCube new
		size: 10;
		elementsOn: (1 to: 20).
	RWEdgeBuilder new
		view: v;
		elements: boxes;
		connectFrom: [ :value | value // 2 ] to: #yourself.
	v addAll: boxes.
	RWForceBasedLayout2D on: boxes.
]
