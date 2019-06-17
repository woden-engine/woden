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
		'temporaryMipmapResultBuffer'
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

{ #category : #public }
WDCProceduralOfflineTextureRenderer >> end [
	
]

{ #category : #public }
WDCProceduralOfflineTextureRenderer >> finish [
	engine graphicsQueue finishExecution.

]

{ #category : #'as yet unclassified' }
WDCProceduralOfflineTextureRenderer >> generateMipmapFromResultBufferWithExtent: extent
fetchWith: fetchFunctionName mipmapWith: mipmapComputationFunctionName
encodeWith: imageEncodingFunctionName for: textureDataLayer [

	| shaderArguments pushConstantBuffer |
	
	"Set the shader arguments."
	shaderArguments := self mipmapGenerationShaderParameters.
	shaderArguments
		storageBuffer: self temporaryMipmapComputationBuffer slot: 0;
		storageBuffer: self temporaryMipmapResultBuffer slot: 1.

	pushConstantBuffer := SLVMNativeArray for: #uint new: 3.
	pushConstantBuffer
		at: 1 put: extent x*extent y;
		at: 2 put: extent x;
		at: 3 put: extent y.

	"Fetch the texture data."
	stateTracker
		computeShader: (self mipmapGenerationLibrary getComputeStage: fetchFunctionName) arguments: shaderArguments;
		pushConstants: 0 size: pushConstantBuffer rawDataSize values: pushConstantBuffer rawData;
		dispatchComputeGlobalGridX: extent x y: extent y;
		computeShaderBuffersReadWriteMemoryBarrier.
		
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

	pushConstantBuffer at: 1 put: destLevelIndex.

	pushConstantBuffer
		at: 1 put: destLevelIndex;
		at: 2 put: firstLevel width*2;
		at: 3 put: firstLevel height.
	
	stateTracker
		pushConstants: 0 size: pushConstantBuffer rawDataSize values: pushConstantBuffer rawData;
		computeShader: (mipmapGenerationLibrary getComputeStage: imageEncodingFunctionName) arguments: shaderArguments;
		dispatchComputeGlobalGridX: firstLevel width*2 y: firstLevel height

]

{ #category : #initialization }
WDCProceduralOfflineTextureRenderer >> generateOfflineProceduralTexture: texture fetchWith: textureFetchFunctionName mipmapWithComputationFunctionName: mipmapComputationFunctionName
imageEncodingFunctionName: imageEncodingFunctionName textureDataLayer: textureDataLayer [

	| extent shaderArguments pushConstantBuffer |
	extent := textureDataLayer width @ textureDataLayer height.
	
	"Set the shader arguments."
	shaderArguments := self mipmapGenerationShaderParameters.
	shaderArguments
		sampledTexture: texture slot: 0;
		storageBuffer: self temporaryMipmapComputationBuffer slot: 0;
		storageBuffer: self temporaryMipmapResultBuffer slot: 1.

	pushConstantBuffer := SLVMNativeArray for: #uint new: 2.
	pushConstantBuffer
		at: 1 put: extent x;
		at: 2 put: extent y.

	"Fetch the texture data."
	stateTracker
		computeShader: (self mipmapGenerationLibrary getComputeStage: textureFetchFunctionName) arguments: shaderArguments;
		pushConstants: 0 size: pushConstantBuffer rawDataSize values: pushConstantBuffer rawData;
		dispatchComputeGlobalGridX: extent x y: extent y;
		computeShaderBuffersReadWriteMemoryBarrier.
		
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

{ #category : #public }
WDCProceduralOfflineTextureRenderer >> readMipmapLevelsInto: textureLayerData [
	textureLayerData readLevelsFromPointer: self temporaryMipmapResultBuffer validPointer.

]

{ #category : #public }
WDCProceduralOfflineTextureRenderer >> renderProceduralTextureWithFragmentShader: shader extent: extent format: pixelFormat [
	| renderTarget |
	renderTarget := self temporaryRenderTargetWithPixelFormat: pixelFormat.
	lastRenderedTexture := self temporaryRenderTargetTextureWithPixelFormat: pixelFormat.
	stateTracker
		beginRenderPass: renderTarget validMainRenderPass renderTarget: renderTarget x: 0 y: 0 width: extent x height: extent y;
		activateShaderSignature: (WDCCompositionShaderSignature for: engine);
		vertexShader: engine resourceCache screenQuadVertexShader;
		fragmentShader: shader;
		dispatchScreenQuadRender;
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
