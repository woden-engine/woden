state binding
fetchShaders
	vertexShader ifNil: [
		vertexShader := engine loadVertexShader: 'shaders/surface/waterVertex.dastrel'.
	].

	fragmentShader ifNil: [ 
		skyTexture ifNotNil: [
			fragmentShader := engine loadFragmentShader: 'shaders/surface/waterSkyForward.dastrel'.
		] ifNil: [ 
			fragmentShader := engine loadFragmentShader: 'shaders/surface/waterColorForward.dastrel'.
		].
	].