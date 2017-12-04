state binding
fetchShaders
	vertexShader ifNil: [
		vertexShader := engine loadVertexShader: 'shaders/surface/waterVertex.dastrel'.
	].

	fragmentShader ifNil: [ 
		skyTexture ifNil: [
			fragmentShader := engine loadFragmentShader: 'shaders/surface/waterSkyForward.dastrel'.
		] ifNotNil: [ 
			fragmentShader := engine loadFragmentShader: 'shaders/surface/waterColorForward.dastrel'.
		].
	].