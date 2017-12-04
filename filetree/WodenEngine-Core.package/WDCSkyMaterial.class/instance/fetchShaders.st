state binding
fetchShaders
	vertexShader ifNil: [
		vertexShader := engine loadVertexShader: 'shaders/surface/skyVertex.dastrel'.
	].

	fragmentShader ifNil: [
		fragmentShader := engine loadFragmentShader: 'shaders/surface/skyFragment.dastrel'.
	].