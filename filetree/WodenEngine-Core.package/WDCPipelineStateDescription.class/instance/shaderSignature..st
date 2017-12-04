accessing
shaderSignature: newShaderSignature
	fragmentShader ~~ newShaderSignature ifTrue: [ self changed ].
	shaderSignature := newShaderSignature