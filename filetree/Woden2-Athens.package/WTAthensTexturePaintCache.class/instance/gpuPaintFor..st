as yet unclassified
gpuPaintFor: thumbnail
	| shaderSignature binding |
	thumbnail isColor ifTrue: [ ^ thumbnail ].
	cachedTextures at: thumbnail ifPresent: [ :existing | ^ existing ].
	thumbnail isForm ifTrue: [
		^ cachedTextures at: thumbnail put: (self gpuPaintFor: (engine createTextureFromForm: thumbnail))
	].
	
	shaderSignature := engine pipelineStateCache shaderSignatureNamed: #GUI.
	binding := engine createShaderSignature: shaderSignature resourceBinding: 1.
	binding bindTexture: 0 texture: thumbnail startMiplevel: 0 miplevels: -1 lodclamp: 10000.0.
	^ cachedTextures at: thumbnail put: (WTAthensTexture new texture: thumbnail; binding: binding)