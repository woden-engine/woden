Class {
	#name : #WDCProceduralOfflineTextureRenderer,
	#superclass : #Object,
	#instVars : [
		'mutex',
		'engine',
		'bufferExtent',
		'temporaryRenderTargetTexture',
		'temporaryRenderTargetTextures',
		'mipmapGenerationShaderParameters',
		'temporaryMipmapComputationBuffer',
		'mipmapGenerationLibrary',
		'stateTracker',
		'commandAllocator',
		'commandList',
		'temporaryRenderTargets',
		'lastRenderedTexture',
		'temporaryMipmapResultBuffer',
		'cubeFaceId',
		'proceduralTextureRendererInputTextures'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Texture'
}

{ #category : #'instance creation' }
WDCProceduralOfflineTextureRenderer class >> for: anEngine extent: anExtent [
	^ self basicNew initializeWithEngine: anEngine bufferExtent: anExtent; yourself
]

{ #category : #public }
WDCProceduralOfflineTextureRenderer >> begin [
	lastRenderedTexture := nil.
	cubeFaceId := nil.
	proceduralTextureRendererInputTextures := nil.
]

{ #category : #accessing }
WDCProceduralOfflineTextureRenderer >> bufferExtent [
	^ bufferExtent
]

{ #category : #public }
WDCProceduralOfflineTextureRenderer >> commandAllocator [
	^ commandAllocator ifNil: [ commandAllocator := engine createGraphicsDirectCommandListAllocator ]
]

{ #category : #public }
WDCProceduralOfflineTextureRenderer >> commandList [
	^ commandList ifNil: [ commandList := self commandAllocator createListNow ]
]

{ #category : #'as yet unclassified' }
WDCProceduralOfflineTextureRenderer >> createNormalTextureFromForm: form [
	| extent result resultLayer resultTopLevel |
	extent := form extent.
	form depth ~= 32 ifTrue: [
		^ form asFormOfDepth: 32
	].

	result := WDCTextureData
		extent: extent bpp: 32 format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM.
	result normalMap: true.
	resultLayer := result layers first.
	resultTopLevel := resultLayer levels first.
	
	self critical: [
		form unhibernate.
		LibC memCopy: form bits to: self temporaryMipmapResultBuffer validPointer size: resultTopLevel data size.
		
		self renderWith: [
			self generateMipmapFromResultBufferWithExtent: extent
				fetchWith: #decode_bgra8_normalXYZ mipmapWith: #mipmap_normal encodeWith: #encode_bgra_normal for: resultLayer
		].
	
		self submit; finish;
			readMipmapLevelsInto: resultLayer
	].
	
	^ result
]

{ #category : #'as yet unclassified' }
WDCProceduralOfflineTextureRenderer >> createSRGBTextureDataFromForm: form [
	| extent result resultLayer resultTopLevel |
	extent := form extent.
	form depth ~= 32 ifTrue: [
		^ form asFormOfDepth: 32
	].

	result := WDCTextureData
		extent: extent bpp: 32 format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM srgbFormat: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB.
	resultLayer := result layers first.
	resultTopLevel := resultLayer levels first.
	
	self critical: [
		form unhibernate.
		LibC memCopy: form bits to: self temporaryMipmapResultBuffer validPointer size: resultTopLevel data size.
		
		self renderWith: [
			self generateMipmapFromResultBufferWithExtent: extent
				fetchWith: #decode_bgra8_srgb mipmapWith: #mipmap encodeWith: #encode_bgra8_srgb for: resultLayer
		].
	
		self submit; finish;
			readMipmapLevelsInto: resultLayer
	].
	
	^ result
]

{ #category : #'as yet unclassified' }
WDCProceduralOfflineTextureRenderer >> createTextureDataFromForm: form [
	| extent result resultLayer resultTopLevel |
	extent := form extent.
	form depth ~= 32 ifTrue: [
		^ form asFormOfDepth: 32
	].

	result := WDCTextureData
		extent: extent bpp: 32 format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM.
	resultLayer := result layers first.
	resultTopLevel := resultLayer levels first.
	
	self critical: [
		form unhibernate.
		LibC memCopy: form bits to: self temporaryMipmapResultBuffer validPointer size: resultTopLevel data size.
		
		self renderWith: [
			self generateMipmapFromResultBufferWithExtent: extent
				fetchWith: #decode_bgra8 mipmapWith: #mipmap encodeWith: #encode_bgra8 for: resultLayer
		].
	
		self submit; finish;
			readMipmapLevelsInto: resultLayer
	].
	
	^ result
]

{ #category : #public }
WDCProceduralOfflineTextureRenderer >> critical: aBlock [
	^ mutex critical: aBlock
]

{ #category : #accessing }
WDCProceduralOfflineTextureRenderer >> cubeFaceId [
	^ cubeFaceId
]

{ #category : #accessing }
WDCProceduralOfflineTextureRenderer >> cubeFaceId: anInteger [
	cubeFaceId := anInteger
]

{ #category : #initialization }
WDCProceduralOfflineTextureRenderer >> encodeMipmapsToBufferWith: imageEncodingFunctionName texelCount: texelCount parameters: shaderArguments [
	| computationGridWidth computationGridHeight pushConstantBuffer |
	computationGridWidth := (texelCount sqrt + 0.5) ceiling asInteger max: 1.
	computationGridHeight := (texelCount + computationGridWidth - 1) // computationGridWidth.
	self assert: computationGridWidth * computationGridHeight >= texelCount.

	pushConstantBuffer := SLVMNativeArray for: #uint new: 3.
	pushConstantBuffer
		at: 1 put: texelCount;
		at: 2 put: computationGridWidth;
		at: 3 put: computationGridHeight.

	stateTracker
		pushConstants: 0 size: pushConstantBuffer rawDataSize values: pushConstantBuffer rawData;
		computeShader: (self mipmapGenerationLibrary getComputeStage: imageEncodingFunctionName) arguments: shaderArguments;
		dispatchComputeGlobalGridX: computationGridWidth y: computationGridHeight
]

{ #category : #public }
WDCProceduralOfflineTextureRenderer >> end [
	
]

{ #category : #'as yet unclassified' }
WDCProceduralOfflineTextureRenderer >> fetchTextureDataWith: fetchFunctionName extent: extent destIndex: destIndex shaderArguments: shaderArguments [
	| pushConstantBuffer |
	pushConstantBuffer := SLVMNativeArray for: #uint new: 4.
	pushConstantBuffer
		at: 1 put: extent x*extent y;
		at: 2 put: extent x;
		at: 3 put: extent y;
		at: 4 put: destIndex.

	"Fetch the texture data."
	stateTracker
		computeShader: (self mipmapGenerationLibrary getComputeStage: fetchFunctionName) arguments: shaderArguments;
		pushConstants: 0 size: pushConstantBuffer rawDataSize values: pushConstantBuffer rawData;
		dispatchComputeGlobalGridX: extent x y: extent y;
		computeShaderBuffersReadWriteMemoryBarrier.

]

{ #category : #public }
WDCProceduralOfflineTextureRenderer >> finish [
	engine graphicsQueue finishExecution.

]

{ #category : #'as yet unclassified' }
WDCProceduralOfflineTextureRenderer >> generateMipmapFromResultBufferWithExtent: extent
fetchWith: fetchFunctionName mipmapWith: mipmapComputationFunctionName
encodeWith: imageEncodingFunctionName for: textureDataLayer [

	| shaderArguments |
	
	"Set the shader arguments."
	shaderArguments := self mipmapGenerationShaderParameters.
	shaderArguments
		storageBuffer: self temporaryMipmapComputationBuffer slot: 0;
		storageBuffer: self temporaryMipmapResultBuffer slot: 1.
	self
		fetchTextureDataWith: fetchFunctionName extent: extent
		destIndex: 0 shaderArguments: shaderArguments.
		
	"Generate the mipmaps."
	self generateOfflineMipmapDataBufferWithParameters: shaderArguments
				mipmapComputationFunctionName: mipmapComputationFunctionName 
				imageEncodingFunctionName: imageEncodingFunctionName
				textureDataLayer: textureDataLayer.

]

{ #category : #initialization }
WDCProceduralOfflineTextureRenderer >> generateOfflineMipmapDataBufferWithParameters: shaderArguments mipmapComputationFunctionName: mipmapComputationFunctionName
imageEncodingFunctionName: imageEncodingFunctionName textureDataLayer: textureDataLayer [
	| pushConstantBuffer sourceLevelIndex sourceLevel destLevelIndex firstLevel |
	pushConstantBuffer := SLVMNativeArray for: #uint new: 6.

	stateTracker
		computeShader: (self mipmapGenerationLibrary getComputeStage: mipmapComputationFunctionName) arguments: shaderArguments.

	firstLevel := textureDataLayer levels first.
	sourceLevelIndex := 0.
	sourceLevel := firstLevel.
	destLevelIndex := sourceLevel pixelCount.
		
	textureDataLayer levels allButFirstDo: [ :destLevel |
		pushConstantBuffer replaceFrom: 1 to: 6 with: {
			sourceLevelIndex.
			sourceLevel width.
			sourceLevel height.
			destLevelIndex.
			destLevel width.
			destLevel height
		}.
			
		stateTracker
			pushConstants: 0 size: pushConstantBuffer rawDataSize values: pushConstantBuffer rawData;
			dispatchComputeGlobalGridX: destLevel width y: destLevel height;
			computeShaderBuffersReadWriteMemoryBarrier.
		
		sourceLevelIndex := destLevelIndex.
		destLevelIndex := destLevelIndex + destLevel pixelCount.
		sourceLevel := destLevel
	].

	self encodeMipmapsToBufferWith: imageEncodingFunctionName texelCount: destLevelIndex parameters: shaderArguments.



]

{ #category : #initialization }
WDCProceduralOfflineTextureRenderer >> generateOfflineProceduralTexture: texture fetchWith: textureFetchFunctionName mipmapWithComputationFunctionName: mipmapComputationFunctionName
imageEncodingFunctionName: imageEncodingFunctionName textureDataLayer: textureDataLayer [

	| extent shaderArguments |
	extent := textureDataLayer width @ textureDataLayer height.
	
	"Set the shader arguments."
	shaderArguments := self mipmapGenerationShaderParameters.
	shaderArguments
		sampledTexture: texture slot: 0;
		storageBuffer: self temporaryMipmapComputationBuffer slot: 0;
		storageBuffer: self temporaryMipmapResultBuffer slot: 1.

	self 
		fetchTextureDataWith: textureFetchFunctionName extent: extent destIndex: 0 shaderArguments: shaderArguments.
		
	"Generate the mipmaps."
	self generateOfflineMipmapDataBufferWithParameters: shaderArguments
				mipmapComputationFunctionName: mipmapComputationFunctionName 
				imageEncodingFunctionName: imageEncodingFunctionName
				textureDataLayer: textureDataLayer.

]

{ #category : #initialization }
WDCProceduralOfflineTextureRenderer >> generateOfflineProceduralTexture: texture mipmapWithComputationFunctionName: mipmapComputationFunctionName
imageEncodingFunctionName: imageEncodingFunctionName textureDataLayer: textureDataLayer [
	^ self generateOfflineProceduralTexture: texture fetchWith: #fetch_texture mipmapWithComputationFunctionName: mipmapComputationFunctionName
imageEncodingFunctionName: imageEncodingFunctionName textureDataLayer: textureDataLayer

]

{ #category : #public }
WDCProceduralOfflineTextureRenderer >> generateProceduralTextureWithExtent: extent fetchWith: textureFetchFunctionName mipmapWith: mipmapComputationFunction encodeWith: encodeFunctionName for: resultLayer [
	self generateOfflineProceduralTexture: lastRenderedTexture fetchWith: textureFetchFunctionName mipmapWithComputationFunctionName: mipmapComputationFunction
imageEncodingFunctionName: encodeFunctionName textureDataLayer: resultLayer
]

{ #category : #public }
WDCProceduralOfflineTextureRenderer >> generateProceduralTextureWithExtent: extent mipmapWith: mipmapComputationFunction encodeWith: encodeFunctionName for: resultLayer [
	self generateOfflineProceduralTexture: lastRenderedTexture mipmapWithComputationFunctionName: mipmapComputationFunction
imageEncodingFunctionName: encodeFunctionName textureDataLayer: resultLayer
]

{ #category : #initialization }
WDCProceduralOfflineTextureRenderer >> initializeWithEngine: anEngine bufferExtent: aBufferExtent [
	mutex := Semaphore forMutualExclusion.
	engine := anEngine.
	bufferExtent := aBufferExtent.
	temporaryRenderTargetTextures := Dictionary new.
	temporaryRenderTargets := Dictionary new.
	
]

{ #category : #initialization }
WDCProceduralOfflineTextureRenderer >> mipmapGenerationLibrary [
	^ mipmapGenerationLibrary ifNil: [mipmapGenerationLibrary := engine resourceCache proceduralMipmapGenerationLibrary]
]

{ #category : #initialization }
WDCProceduralOfflineTextureRenderer >> mipmapGenerationShaderParameters [
	^ mipmapGenerationShaderParameters ifNil: [ mipmapGenerationShaderParameters := engine newGenericComputeShaderArguments ]
]

{ #category : #'as yet unclassified' }
WDCProceduralOfflineTextureRenderer >> proceduralTextureRendererInputTextures: inputTextures [
	proceduralTextureRendererInputTextures := (WDCCompositionShaderSignature for: engine) newSources.
	inputTextures doWithIndex: [ :texture :index |
		proceduralTextureRendererInputTextures bind: index - 1 texture: texture
	]

]

{ #category : #public }
WDCProceduralOfflineTextureRenderer >> readMipmapLevelsInto: textureLayerData [
	textureLayerData readLevelsFromPointer: self temporaryMipmapResultBuffer validPointer.

]

{ #category : #public }
WDCProceduralOfflineTextureRenderer >> renderProceduralTextureMipmaps: levelCount withFragmentShader: shader extent: extent format: format [
	| width height destIndex pushConstants texelCount currentExtent |
	width := extent x.
	height := extent y.
	currentExtent := extent.
	destIndex := 0.
	pushConstants := SLVMNativeArray for: #uint new: 2.
	
	1 to: levelCount do: [ :i |
		texelCount := width * height.
		pushConstants
			at: 1 put: i - 1;
			at: 2 put: levelCount.
		self renderProceduralTextureWithFragmentShader: shader
			pushConstants: pushConstants rawData extent: currentExtent
			format: format.
			
		self fetchTextureDataWith: #fetch_texture extent: currentExtent destIndex: destIndex shaderArguments: self mipmapGenerationShaderParameters.
		destIndex := destIndex + texelCount.
		width := width // 2 max: 1.
		height := height // 2 max: 1.
		currentExtent := width @ height
	].

	^ destIndex
]

{ #category : #public }
WDCProceduralOfflineTextureRenderer >> renderProceduralTextureMipmapsWithFragmentShader: shader extent: extent format: pixelFormat encodeWith: encodingFunction intoTextureLayerData: resultLayer [
	| shaderArguments texture texelCount |
	texture := self temporaryRenderTargetTextureWithPixelFormat: pixelFormat.

	shaderArguments := self mipmapGenerationShaderParameters.
	shaderArguments
		sampledTexture: texture slot: 0;
		storageBuffer: self temporaryMipmapComputationBuffer slot: 0;
		storageBuffer: self temporaryMipmapResultBuffer slot: 1.

	texelCount := self
		renderProceduralTextureMipmaps: resultLayer levels size withFragmentShader: shader extent: extent format: pixelFormat.
	self encodeMipmapsToBufferWith: encodingFunction texelCount: texelCount parameters: shaderArguments.
]

{ #category : #public }
WDCProceduralOfflineTextureRenderer >> renderProceduralTextureWithFragmentShader: shader extent: extent format: pixelFormat [
	self renderProceduralTextureWithFragmentShader: shader pushConstants: nil extent: extent format: pixelFormat
]

{ #category : #public }
WDCProceduralOfflineTextureRenderer >> renderProceduralTextureWithFragmentShader: shader pushConstants: pushConstants extent: extent format: pixelFormat [
	| renderTarget |
	renderTarget := self temporaryRenderTargetWithPixelFormat: pixelFormat.
	lastRenderedTexture := self temporaryRenderTargetTextureWithPixelFormat: pixelFormat.
	stateTracker
		beginRenderPass: renderTarget validMainRenderPass renderTarget: renderTarget x: 0 y: 0 width: extent x height: extent y;
		activateShaderSignature: (WDCCompositionShaderSignature for: engine).
	proceduralTextureRendererInputTextures ifNotNil: [ stateTracker useShaderResources: proceduralTextureRendererInputTextures ].
	stateTracker
		vertexShader: (cubeFaceId
			ifNil: [engine resourceCache screenQuadVertexShader]
			ifNotNil: [engine resourceCache cubeScreenQuadVertexShader]);
		fragmentShader: shader.

	pushConstants ifNotNil: [
		stateTracker pushConstants: 0 size: pushConstants size values: pushConstants
	].

	cubeFaceId ifNil: [ 
		stateTracker
			dispatchScreenQuadRender.
	] ifNotNil: 	[ 
		stateTracker
			dispatchCubeFaceScreenQuadRender: cubeFaceId.
	].

	stateTracker
		endRenderPass.

]

{ #category : #public }
WDCProceduralOfflineTextureRenderer >> renderWith: aBlock [
	self commandAllocator reset.
	
	stateTracker := WDCStateTracker for: engine.
	stateTracker commandList: self commandList rebuildWith: [
		self begin.
		aBlock cull: self.
		self end
	].

]

{ #category : #public }
WDCProceduralOfflineTextureRenderer >> submit [
	engine graphicsQueue addCommandList: commandList validHandle
]

{ #category : #initialization }
WDCProceduralOfflineTextureRenderer >> temporaryMipmapComputationBuffer [
	| requiredBytes |
	^ temporaryMipmapComputationBuffer ifNil: [
		requiredBytes := bufferExtent x * bufferExtent y * 16*2.
		temporaryMipmapComputationBuffer := engine createStreamingStorageBuffer: requiredBytes initialData: nil
	]
]

{ #category : #initialization }
WDCProceduralOfflineTextureRenderer >> temporaryMipmapResultBuffer [
	| requiredBytes |
	^ temporaryMipmapResultBuffer ifNil: [
		requiredBytes := bufferExtent x * bufferExtent y * 4*2.
		temporaryMipmapResultBuffer := engine createStreamingStorageBuffer: requiredBytes initialData: nil
	]
]

{ #category : #accessing }
WDCProceduralOfflineTextureRenderer >> temporaryRenderTargetTextureWithPixelFormat: pixelFormat [
	^ temporaryRenderTargetTextures at: pixelFormat ifAbsentPut: [
		engine createTexture: (AGPUTextureDescription new
			type: AGPU_TEXTURE_2D;
			format: pixelFormat;
			width: bufferExtent x asLargerPowerOfTwo;
			height: bufferExtent y asLargerPowerOfTwo;
			depth: 1;
			layers: 1;
			miplevels: 1;
			sample_count: 1;
			sample_quality: 0;
			heap_type: AGPU_MEMORY_HEAP_TYPE_DEVICE_LOCAL;
			usage_modes: AGPU_TEXTURE_USAGE_SAMPLED | AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT;
			main_usage_mode: AGPU_TEXTURE_USAGE_SAMPLED;
			yourself
		)
	].

]

{ #category : #accessing }
WDCProceduralOfflineTextureRenderer >> temporaryRenderTargetWithPixelFormat: pixelFormat [
	^ temporaryRenderTargets at: pixelFormat ifAbsentPut: [
		WDCRenderTarget for: engine colorAttachments: {self temporaryRenderTargetTextureWithPixelFormat: pixelFormat}
	].

]
