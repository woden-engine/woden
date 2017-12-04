accessing
vertexShader: newVertexShader
	vertexShader ~~ newVertexShader ifTrue: [ self changed ].
	vertexShader := newVertexShader