viewport composition
vertexShader
	^ vertexShader ifNil: [ vertexShader := engine loadVertexShader: self vertexShaderFileName ]