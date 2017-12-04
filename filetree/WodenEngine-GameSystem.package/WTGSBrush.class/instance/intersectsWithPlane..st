intersection
intersectsWithPlane: aPlane
	| front back |
	front := false.
	back := false.
	positions do: [ :vert |
		(aPlane isInFront: vert) ifTrue: [ front := true ] ifFalse: [ back := true ].
		(front and: back) ifTrue: [ ^ true ].
	].
	^ front and: back