intersection
intersectsWithBrushProperly: brush
	"Make sure we don't share a face."
	faces do: [ :myface |
		| plane  |
		plane := myface plane negated.
		brush faces do: [:face |
			(face plane closeTo: plane) ifTrue: [ ^ false ].
		]
	].

	positions do: [ :vert | (brush containsPointInside: vert) ifTrue: [ ^ true ] ].
	faces do: [ :face |
		face edgesDo: [ :start :end |
			(brush intersectsWithEdgeProperly: (face positionAt: start) end: (face positionAt: end)) ifTrue: [^ true]
		].
	].

	^ false