state binding
fetchShaders

	vertexShader ifNil: [ 
		isSkinned ifTrue: [
			vertexShader := engine loadVertexShader: 'shaders/surface/skinnedGenericVertex.dastrel'.
		] ifFalse: [ 
			vertexShader := engine loadVertexShader: 'shaders/surface/genericVertex.dastrel'.
		]
	].

	albedoTexture ifNotNil: [ 
		normalTexture ifNotNil: [
			fresnelTexture ifNotNil: [
				fragmentShader := engine loadFragmentShader: 'shaders/surface/albedoNormalFresnelTexture.dastrel'.
			] ifNil: [
				fragmentShader := engine loadFragmentShader: 'shaders/surface/albedoNormalTexture.dastrel'.
			]		
		] ifNil: [
			fresnelTexture ifNotNil: [ 
				fragmentShader := engine loadFragmentShader: 'shaders/surface/albedoFresnelTexture.dastrel'.
			] ifNil: [
				fragmentShader := engine loadFragmentShader: 'shaders/surface/albedoTexture.dastrel'.
			]
		]	
	] ifNil: [
		fragmentShader := engine loadFragmentShader: 'shaders/surface/colorForward.dastrel'.
	]
