intersection
intersectsWithFaceProperly: face
	| reversedPlane |
	reversedPlane := face plane negated.
	self faces do: [ :myface |
		((myface plane closeTo: face plane) or: [myface plane closeTo: reversedPlane]) ifTrue: [ ^ false ]
	].
	
	face positionsDo: [ :vert | (self containsPointInside: vert) ifTrue: [ ^ true ] ].
	face edgesDo: [ :start :end | (self intersectsWithEdgeProperly: (face positionAt: start) end: (face positionAt: end)) ifTrue: [^ true ] ].
	^ false