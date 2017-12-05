viewport composition
fragmentShader
	^ fragmentShader ifNil: [ fragmentShader := engine loadFragmentShader: self fragmentShaderFileName ]