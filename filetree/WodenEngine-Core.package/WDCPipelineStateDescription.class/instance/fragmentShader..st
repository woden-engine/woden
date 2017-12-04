accessing
fragmentShader: newFragmentShader
	fragmentShader ~~ newFragmentShader ifTrue: [ self changed ].
	fragmentShader := newFragmentShader.