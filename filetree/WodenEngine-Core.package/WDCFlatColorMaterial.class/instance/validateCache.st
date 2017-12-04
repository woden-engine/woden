state binding
validateCache
	vertexShader ifNil: [
		vertexShader := engine loadVertexShader: 'shaders/surface/genericVertex.dastrel'.
	].

	fragmentShader ifNil: [
		stipple ifFalse: [
			fragmentShader := engine loadFragmentShader: 'shaders/surface/flatColorForward.dastrel'.
		] ifTrue: [ 
			fragmentShader := engine loadFragmentShader: 'shaders/surface/flatColorStipple.dastrel'.
		].
	]