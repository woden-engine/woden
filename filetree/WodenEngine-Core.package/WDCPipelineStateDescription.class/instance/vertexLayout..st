accessing
vertexLayout: newVertexLayout
	vertexLayout ~~ newVertexLayout ifTrue: [ self changed ].
	vertexLayout := newVertexLayout