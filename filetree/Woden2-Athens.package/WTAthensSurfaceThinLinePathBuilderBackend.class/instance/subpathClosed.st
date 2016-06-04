commands
subpathClosed
	closed ifTrue: [ ^ self ].
	subpathVertexCount > 2 ifTrue: [ 
		surface
			addIndex: subpathFirstVertex + subpathVertexCount - 1;
			addIndex: subpathFirstVertex.
	].

	closed := true.