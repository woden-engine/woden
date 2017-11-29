as yet unclassified
sideOfPlane: aPlane
	| front back |
	front := false.
	back := false.
	
	self positionsDo: [ :vert |
		(aPlane isInFront: vert) ifTrue: [ front := true ] ifFalse: [ back := true ].
		(front and: back) ifTrue: [ ^ 0 ].
	].

	(front and: back) ifTrue: [ ^ 0 ].
	^ front ifTrue: [ 1 ] ifFalse: [ -1 ].
