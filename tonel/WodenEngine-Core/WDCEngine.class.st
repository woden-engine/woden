Class {
	#name : #WDCEngine,
	#superclass : #Object,
	#instVars : [
		'frameBufferingDriver',
		'projectionInvertedY',
		'assetSearchPaths',
		'session',
		'device',
		'graphicsQueue',
		'preferredDepthFormat',
		'preferredDepthStencilFormat',
		'resourceCache',
		'soundDevice',
		'babylonDriver',
		'hasTopLeftNDCOrigin',
		'hasBottomLeftTextureCoordinates',
		'projectiveTextureBiasMatrix',
		'vrSystem'
	],
	#classVars : [
		'AllowVR',
		'DebugLayerEnabled',
		'DefaultEngine',
		'GenerateOfflineMipmapsGPU',
		'SSAOEnabled',
		'ShadowMappingEnabled',
		'TracingEnabled'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Engine'
}

{ #category : #preferences }
WDCEngine class >> allowVR [
	^ AllowVR ifNil: [ AllowVR := false ]
]

{ #category : #preferences }
WDCEngine class >> allowVR: aBoolean [
	AllowVR := aBoolean
]

{ #category : #preferences }
WDCEngine class >> debugLayerEnabled [
	^ DebugLayerEnabled ifNil: [ DebugLayerEnabled := false ]
]

{ #category : #preferences }
WDCEngine class >> debugLayerEnabled: aBoolean [
	^ DebugLayerEnabled := aBoolean
]

{ #category : #accessing }
WDCEngine class >> default [
	^ DefaultEngine ifNil: [ DefaultEngine := self new ]
]

{ #category : #'as yet unclassified' }
WDCEngine class >> generateOfflineMipmapsGPU [
	^ GenerateOfflineMipmapsGPU ifNil: [ GenerateOfflineMipmapsGPU := true ]
]

{ #category : #'as yet unclassified' }
WDCEngine class >> generateOfflineMipmapsGPU: aBoolean [
	GenerateOfflineMipmapsGPU := aBoolean
]

{ #category : #'as yet unclassified' }
WDCEngine class >> gpuBasedParticleSimulation [
	^ true
]

{ #category : #accessing }
WDCEngine class >> reset [
	<script: 'self reset'>
	
	DefaultEngine := nil
]

{ #category : #preferences }
WDCEngine class >> shadowMappingEnabled [
	^ ShadowMappingEnabled ifNil: [ ShadowMappingEnabled := true]
]

{ #category : #preferences }
WDCEngine class >> shadowMappingEnabled: aBoolean [
	ShadowMappingEnabled := aBoolean
]

{ #category : #preferences }
WDCEngine class >> ssaoEnabled [
	^ SSAOEnabled ifNil: [ SSAOEnabled := false ]
]

{ #category : #preferences }
WDCEngine class >> ssaoEnabled: aBoolean [
	SSAOEnabled := aBoolean
]

{ #category : #preferences }
WDCEngine class >> tracingEnabled [
	^ TracingEnabled ifNil: [ TracingEnabled := false ]
]

{ #category : #preferences }
WDCEngine class >> tracingEnabled: aBoolean [
	TracingEnabled := aBoolean
]

{ #category : #accessing }
WDCEngine class >> unsuspendAll [
	^ self allInstancesDo: #unsuspendAll
]

{ #category : #settings }
WDCEngine class >> wodenSettingsOn: aBuilder [
	<systemsettings>
	(aBuilder group: #woden)
		label: 'Woden';
		description: 'Woden Engine Settings';
		with: [
			(aBuilder setting: #debugLayerEnabled)
				label: 'Debug Layer enabled';
				description: 'This enables the graphics API debug layer (Vulkan Only).'.
			(aBuilder setting: #allowVR)
				label: 'Allow VR';
				description: 'This enables the support for VR (OpenVR headers such as the HTC Vive).'.
			(aBuilder setting: #tracingEnabled)
				label: 'Tracing enabled';
				description: 'This enables the support for tracing engine logs.'.
			(aBuilder setting: #ssaoEnabled)
				label: 'SSAO enabled';
				description: 'This enables the support for screen space ambient occlusion.'.
			(aBuilder setting: #shadowMappingEnabled)
				label: 'Shadow Mapping enabled';
				description: 'This enables the support shadow maps.'.
			(aBuilder setting: #generateOfflineMipmapsGPU)
				label: 'Generate mipmaps for offline textures with the GPU';
				description: 'This enables using compute shaders for mipmap generation..'

		]
]

{ #category : #assets }
WDCEngine >> addAssetSearchPath: aSearchPath [
	| searchPathReference |
	searchPathReference := aSearchPath.
	assetSearchPaths add: aSearchPath asFileReference.
	resourceCache addedAssetSearchPath: searchPathReference.
]

{ #category : #adding }
WDCEngine >> addRenderProcess: aRenderProcess [
	frameBufferingDriver addRenderProcess: aRenderProcess
]

{ #category : #assets }
WDCEngine >> assetSearchPaths [
	^ assetSearchPaths
]

{ #category : #accessing }
WDCEngine >> autoReloadChanges [
	^ true
]

{ #category : #accessing }
WDCEngine >> babylonDriver: aPompeiiDriver [
	babylonDriver := aPompeiiDriver
]

{ #category : #accessing }
WDCEngine >> bufferingFrameIndex [
	^ frameBufferingDriver bufferingFrameIndex
]

{ #category : #accessing }
WDCEngine >> bufferingFrameIndexModule: aModule [
	^ frameBufferingDriver bufferingFrameIndexModule: aModule
]

{ #category : #'session management' }
WDCEngine >> checkSession [
	session ~~ Smalltalk session ifTrue: [
		self initializeForNewSession
	]
]

{ #category : #'resource building' }
WDCEngine >> createBGRAStorageImageWithExtent: anExtent [
	^ self createStorageImageWithExtent: anExtent format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM
]

{ #category : #'resource building' }
WDCEngine >> createBasicRenderPassWithColor: aColor [
	| colorAttachments depthStencilAttachment |
	colorAttachments := {
		AGPURenderpassColorAttachmentDescription new
			format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB;
			begin_action: AGPU_ATTACHMENT_CLEAR;
			end_action: AGPU_ATTACHMENT_KEEP;
			clear_value: aColor asWMVector4F asAGPUColor4f;
			yourself
	}.
		
	depthStencilAttachment := AGPURenderpassDepthStencilDescription new
		format: self preferredDepthStencilFormat;
		begin_action: AGPU_ATTACHMENT_CLEAR;
		end_action: AGPU_ATTACHMENT_KEEP;
		clear_value: (AGPUDepthStencilValue new depth: 0.0; stencil: 0; yourself);
		yourself.
		
	^ (WDCRenderPass for: self)
		colorAttachments: colorAttachments;
		depthStencilAttachment: depthStencilAttachment;
		checkSession;
		yourself
]

{ #category : #'resource building' }
WDCEngine >> createBasicRenderPassWithOnlyColor: aColor [
	| colorAttachments |
	colorAttachments := {
		AGPURenderpassColorAttachmentDescription new
			format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB;
			begin_action: AGPU_ATTACHMENT_CLEAR;
			end_action: AGPU_ATTACHMENT_KEEP;
			clear_value: aColor asWMVector4F asAGPUColor4f;
			yourself
	}.
	^ (WDCRenderPass for: self)
		colorAttachments: colorAttachments;
		checkSession;
		yourself
]

{ #category : #initialization }
WDCEngine >> createDevice [
	| platform deviceOpenInfo |
	platform := AGPU firstPlatform.
	platform ifNil: [ self error: 'Failed to open the AGPU platform' ].

	deviceOpenInfo := AGPUDeviceOpenInfo new debug_layer: self class debugLayerEnabled asBit.
	self class allowVR ifTrue: [ 
		deviceOpenInfo open_flags: AGPU_DEVICE_OPEN_FLAG_ALLOW_VR.
	].
	
	device := platform openDevice: deviceOpenInfo.
	device ifNil: [ self error: 'Failed to open the AGPU device' ].
	
	vrSystem := (device isFeatureSupported: AGPU_FEATURE_VRDISPLAY) ~= 0
		ifTrue: [ WDCAGPUVRSystem for: self ]
		ifFalse: [ WDCDummyVRSystem for: self ].

	graphicsQueue := device getDefaultCommandQueue.

]

{ #category : #'resource building' }
WDCEngine >> createGPUStorageBuffer: size [
	^ self createGPUStorageBuffer: size initialData: nil
]

{ #category : #'resource building' }
WDCEngine >> createGPUStorageBuffer: size initialData: initialData [
	| desc |
	desc := AGPUBufferDescription new
		size: size;
		heap_type: AGPU_MEMORY_HEAP_TYPE_DEVICE_LOCAL;
		binding: AGPU_STORAGE_BUFFER;
		mapping_flags: self streamingMappedBufferMappingFlags;
		stride: 0.
	^ (WDCBufferResource for: self) description: desc; data: initialData; checkSession ; yourself
]

{ #category : #'resource building' }
WDCEngine >> createGraphicsBundleCommandListAllocator [
	^ (WDCCommandListAllocator for: self) bundle; checkSession; yourself
]

{ #category : #'resource building' }
WDCEngine >> createGraphicsDirectCommandListAllocator [
	^ (WDCCommandListAllocator for: self) direct; checkSession; yourself
]

{ #category : #'resource building' }
WDCEngine >> createIndex: indexSize elements: elementCount immutableBuffer: data [
	| desc |
	desc := AGPUBufferDescription new
		size: indexSize*elementCount;
		heap_type: AGPU_MEMORY_HEAP_TYPE_DEVICE_LOCAL;
		binding: AGPU_ELEMENT_ARRAY_BUFFER;
		mapping_flags: 0;
		stride: indexSize.
	^ (WDCBufferResource for: self) description: desc; data: data; checkSession; yourself
]

{ #category : #'resource building' }
WDCEngine >> createIndex: indexSize elements: elementCount streamingData: data [
	| desc |
	desc := AGPUBufferDescription new
		size: indexSize*elementCount;
		heap_type: AGPU_MEMORY_HEAP_TYPE_HOST_TO_DEVICE;
		binding: AGPU_ELEMENT_ARRAY_BUFFER;
		mapping_flags: self streamingMappedBufferMappingFlags;
		stride: indexSize.
	^ (WDCBufferResource for: self) description: desc; data: data; checkSession; yourself
]

{ #category : #'resource building' }
WDCEngine >> createIndex: indexSize streamingElements: elementCount [
	^ self createIndex: indexSize elements: elementCount streamingData: nil
]

{ #category : #'resource building' }
WDCEngine >> createLinearTextureFromForm: aForm [
	^ self createTextureFromForm: aForm format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM
]

{ #category : #'resource building' }
WDCEngine >> createRenderTargetColorTextureWithExtent: anExtent format: aTextureFormat [
	^ self createRenderTargetColorTextureWithExtent: anExtent sampleCount: 1 format: aTextureFormat
]

{ #category : #'resource building' }
WDCEngine >> createRenderTargetColorTextureWithExtent: anExtent sampleCount: sampleCount format: aTextureFormat [
	| width height description |
	width := anExtent x.
	height := anExtent y.
	description := AGPUTextureDescription new
		type: AGPU_TEXTURE_2D;
		format: aTextureFormat;
		width: width;
		height: height;
		depth: 1;
		layers: 1;
		miplevels: 1;
		sample_count: sampleCount;
		sample_quality: 0;
		heap_type: AGPU_MEMORY_HEAP_TYPE_DEVICE_LOCAL;
		usage_modes: AGPU_TEXTURE_USAGE_SAMPLED | AGPU_TEXTURE_USAGE_COLOR_ATTACHMENT;
		main_usage_mode: AGPU_TEXTURE_USAGE_SAMPLED
		yourself.
	^ self createTexture: description
]

{ #category : #initialization }
WDCEngine >> createResourceCache [
	resourceCache ifNil: [
		resourceCache := WDCResourceCache new.
		resourceCache initializeForEngine: self.
 	].

	resourceCache sessionChanged
]

{ #category : #'resource building' }
WDCEngine >> createShaderSignature: shaderSignature resourceBinding: binding elements: elements [
	^ (WDCShaderResourceBinding for: self)
			elements: elements;
			shaderSignature: shaderSignature;
			binding: binding;
			checkSession;
			yourself
]

{ #category : #'resource building' }
WDCEngine >> createSoundListener [
	^ WDCSoundListener for: self
]

{ #category : #'resource building' }
WDCEngine >> createSoundSample [
	^ WDCSoundSample for: self
]

{ #category : #'resource building' }
WDCEngine >> createSoundSource [
	^ WDCSoundSource for: self
]

{ #category : #'resource building' }
WDCEngine >> createStorageImageWithExtent: anExtent [
	^ self createStorageImageWithExtent: anExtent format: AGPU_TEXTURE_FORMAT_R8G8B8A8_UNORM
]

{ #category : #'resource building' }
WDCEngine >> createStorageImageWithExtent: anExtent format: aTextureFormat [
	| width height description |
	width := anExtent x.
	height := anExtent y.
	description := AGPUTextureDescription new
		type: AGPU_TEXTURE_2D;
		format: aTextureFormat;
		width: width;
		height: height;
		depth: 1;
		layers: 1;
		miplevels: 1;
		sample_count: 1;
		sample_quality: 0;
		heap_type: AGPU_MEMORY_HEAP_TYPE_DEVICE_LOCAL;
		usage_modes: AGPU_TEXTURE_USAGE_STORAGE | AGPU_TEXTURE_USAGE_READED_BACK | AGPU_TEXTURE_USAGE_SAMPLED;
		main_usage_mode: AGPU_TEXTURE_USAGE_STORAGE;
		yourself.
	^ (WDCTexture for: self)
		description: description;
		checkSession;
		yourself.
]

{ #category : #'resource building' }
WDCEngine >> createStreamingStorageBuffer: size [
	^ self createStreamingStorageBuffer: size initialData: nil
]

{ #category : #'resource building' }
WDCEngine >> createStreamingStorageBuffer: size initialData: initialData [
	| desc |
	desc := AGPUBufferDescription new
		size: size;
		heap_type: AGPU_MEMORY_HEAP_TYPE_HOST_TO_DEVICE;
		binding: AGPU_STORAGE_BUFFER;
		mapping_flags: self streamingMappedBufferMappingFlags;
		stride: 0.
	^ (WDCBufferResource for: self) description: desc; data: initialData; checkSession ; yourself
]

{ #category : #'resource building' }
WDCEngine >> createStreamingUniformBuffer: size [
	^ self createStreamingUniformBuffer: size initialData: nil
]

{ #category : #'resource building' }
WDCEngine >> createStreamingUniformBuffer: size initialData: initialData [
	| desc |
	desc := AGPUBufferDescription new
		size: size;
		heap_type: AGPU_MEMORY_HEAP_TYPE_HOST_TO_DEVICE;
		binding: AGPU_UNIFORM_BUFFER;
		mapping_flags: self streamingMappedBufferMappingFlags;
		stride: 0.
	^ (WDCBufferResource for: self) description: desc; data: initialData; checkSession ; yourself
]

{ #category : #'resource building' }
WDCEngine >> createTexture: description [
	^ self createTexture: description withData: nil
]

{ #category : #'resource building' }
WDCEngine >> createTexture: description withData: textureData [
	^ (WDCTexture for: self)
			description: description;
			data: textureData;
			checkSession;
			yourself
]

{ #category : #'resource building' }
WDCEngine >> createTextureFromForm: aForm [
	^ self createTextureFromForm: aForm format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB
]

{ #category : #'resource building' }
WDCEngine >> createTextureFromForm: aForm format: aTextureFormat [
	| width height description |
	width := aForm width.
	height := aForm height.
	description := AGPUTextureDescription new
		type: AGPU_TEXTURE_2D;
		format: aTextureFormat;
		width: width;
		height: height;
		depth: 1;
		layers: 1;
		miplevels: 1;
		sample_count: 1;
		sample_quality: 0;
		heap_type: AGPU_MEMORY_HEAP_TYPE_DEVICE_LOCAL;
		usage_modes: AGPU_TEXTURE_USAGE_SAMPLED | AGPU_TEXTURE_USAGE_UPLOADED;
		main_usage_mode: AGPU_TEXTURE_USAGE_SAMPLED;
		yourself.
	^ (WDCTexture for: self)
		description: description; 
		data: aForm;
		checkSession;
		yourself.
]

{ #category : #'resource building' }
WDCEngine >> createUniformBuffer: size immutableData: data [
	| desc |
	desc := AGPUBufferDescription new
		size: size;
		heap_type: AGPU_MEMORY_HEAP_TYPE_DEVICE_LOCAL;
		binding: AGPU_UNIFORM_BUFFER;
		mapping_flags: 0;
		stride: 0.
	^ (WDCBufferResource for: self) description: desc; data: data; yourself
]

{ #category : #'resource building' }
WDCEngine >> createVertex: vertexSize elements: elementCount immutableBuffer: data [
	| desc |
	desc := AGPUBufferDescription new
		size: vertexSize*elementCount;
		heap_type: AGPU_MEMORY_HEAP_TYPE_DEVICE_LOCAL;
		binding: AGPU_ARRAY_BUFFER;
		mapping_flags: 0;
		stride: vertexSize.
	^ (WDCBufferResource for: self) description: desc; data: data; checkSession; yourself
]

{ #category : #'resource building' }
WDCEngine >> createVertex: vertexSize elements: elementCount streamingData: data [
	| desc |
	desc := AGPUBufferDescription new
		size: vertexSize*elementCount;
		heap_type: AGPU_MEMORY_HEAP_TYPE_HOST_TO_DEVICE;
		binding: AGPU_ARRAY_BUFFER;
		mapping_flags: self streamingMappedBufferMappingFlags;
		stride: vertexSize.
	^ (WDCBufferResource for: self) description: desc; data: data; checkSession; yourself
]

{ #category : #'resource building' }
WDCEngine >> createVertex: vertexSize streamingElements: elementCount [
	^ self createVertex: vertexSize elements: elementCount streamingData: nil
]

{ #category : #'resource building' }
WDCEngine >> createVertexBindingForLayout: vertexLayout [
	^ (WDCVertexBinding for: self) vertexLayout: vertexLayout; checkSession; yourself
]

{ #category : #accessing }
WDCEngine >> defaultMaterial [
	^ resourceCache defaultMaterial
]

{ #category : #accessing }
WDCEngine >> device [
	^ device
]

{ #category : #accessing }
WDCEngine >> engine [
	^ self
]

{ #category : #enumerating }
WDCEngine >> frameBufferingCollect: aBlock [
	^ frameBufferingDriver frameBufferingCollect: aBlock
]

{ #category : #enumerating }
WDCEngine >> frameBufferingCount [
	^ frameBufferingDriver frameBufferingCount
]

{ #category : #accessing }
WDCEngine >> frameBufferingDriver [
	^ frameBufferingDriver
]

{ #category : #accessing }
WDCEngine >> getOrCreateShaderSignature: aShaderSignatureClass [
	^ resourceCache getOrCreateShaderSignature: aShaderSignatureClass
]

{ #category : #accessing }
WDCEngine >> graphicsQueue [
	^ graphicsQueue
]

{ #category : #accessing }
WDCEngine >> hasBottomLeftTextureCoordinates [
	^ hasBottomLeftTextureCoordinates
]

{ #category : #testing }
WDCEngine >> hasSupportForVR [
	^ vrSystem hasSupportForVR
]

{ #category : #accessing }
WDCEngine >> hasTopLeftNDCOrigin [
	^ hasTopLeftNDCOrigin
]

{ #category : #accessing }
WDCEngine >> hasTopLeftTextureCoordinates [
	^ hasBottomLeftTextureCoordinates not
]

{ #category : #initialization }
WDCEngine >> initialize [
	super initialize.
	projectionInvertedY := false.
	assetSearchPaths ifNil: [ 
		assetSearchPaths := OrderedCollection new.
		assetSearchPaths add: WodenCoreAssets location.
	].
	self initializeForNewSession.
]

{ #category : #initialization }
WDCEngine >> initializeForNewSession [
	session := Smalltalk session.
	self
		createDevice;
		queryDeviceCapabilities;
		createResourceCache.
	frameBufferingDriver := WDCFrameBufferingDriver for: self.

]

{ #category : #'resource loading' }
WDCEngine >> loadComputeShader: aFileName [
	^ resourceCache loadComputeShader: aFileName
]

{ #category : #'resource loading' }
WDCEngine >> loadFragmentShader: aFileName [
	^ resourceCache loadFragmentShader: aFileName
]

{ #category : #'resource loading' }
WDCEngine >> loadShaderLibrary: aFileName [
	^ resourceCache loadShaderLibrary: aFileName
]

{ #category : #'resource loading' }
WDCEngine >> loadVertexShader: aFileName [
	^ resourceCache loadVertexShader: aFileName
]

{ #category : #'resource building' }
WDCEngine >> newCompositionFullScreenPass [
	^ WDCCompositionFullScreenPass for: self
]

{ #category : #'resource building' }
WDCEngine >> newGenericComputeShaderArguments [
	^ WDCGenericComputeShaderArguments for: self
]

{ #category : #accessing }
WDCEngine >> optimalComputeWorkGroupSize [
	^ 32
]

{ #category : #accessing }
WDCEngine >> preferredDepthFormat [
	^ preferredDepthFormat
]

{ #category : #accessing }
WDCEngine >> preferredDepthStencilFormat [
	^ preferredDepthStencilFormat
]

{ #category : #accessing }
WDCEngine >> projectionInvertedY [
	^ projectionInvertedY
]

{ #category : #accessing }
WDCEngine >> projectiveTextureBiasMatrix [
	^ projectiveTextureBiasMatrix
]

{ #category : #initialization }
WDCEngine >> queryDeviceCapabilities [
	preferredDepthFormat := AGPU_TEXTURE_FORMAT_D32_FLOAT.
	preferredDepthStencilFormat := AGPU_TEXTURE_FORMAT_D32_FLOAT_S8X24_UINT.
	
	hasTopLeftNDCOrigin := device hasTopLeftNdcOrigin ~= 0.
	hasBottomLeftTextureCoordinates := device hasBottomLeftTextureCoordinates ~= 0.
	projectionInvertedY := hasTopLeftNDCOrigin.
	
	"Do we need to flip the texture coordinates when doing projective texturing?"
	self hasTopLeftNDCOrigin ~= self hasTopLeftTextureCoordinates ifTrue: [
		projectiveTextureBiasMatrix := WMMatrix4F newFrom: #(
			0.5  0.0 0.0 0.5
			0.0 -0.5 0.0 0.5
			0.0  0.0 1.0 0.0
			0.0  0.0 0.0 1.0
		)
	] ifFalse: [ 
		projectiveTextureBiasMatrix := WMMatrix4F newFrom: #(
			0.5 0.0 0.0 0.5
			0.0 0.5 0.0 0.5
			0.0 0.0 1.0 0.0
			0.0 0.0 0.0 1.0
		)
	]
]

{ #category : #'as yet unclassified' }
WDCEngine >> renderingProcessCritical: aBlock [
	^ frameBufferingDriver renderingProcessCritical: aBlock
]

{ #category : #accessing }
WDCEngine >> resourceCache [
	^ resourceCache
]

{ #category : #accessing }
WDCEngine >> shadowMappingEnabled [
	^ self class shadowMappingEnabled
]

{ #category : #accessing }
WDCEngine >> soundDevice [
	soundDevice ifNil: [ soundDevice := WDCSoundEngine current createSoundDevice].
	^ soundDevice
]

{ #category : #accessing }
WDCEngine >> ssaoEnabled [
	^ self class ssaoEnabled
]

{ #category : #'resource building' }
WDCEngine >> streamingMappedBufferMappingFlags [
	^ ((AGPU_MAP_READ_BIT
		bitOr: AGPU_MAP_WRITE_BIT)
		bitOr: AGPU_MAP_PERSISTENT_BIT)
		bitOr: AGPU_MAP_COHERENT_BIT
]

{ #category : #tracing }
WDCEngine >> trace: aString [
	self class tracingEnabled ifFalse: [ ^ self ].
	Transcript show: aString; cr.
	FileStream stdout nextPutAll: aString; lf
]

{ #category : #tracing }
WDCEngine >> trace: formatString format: formatArgument [ 
	self class tracingEnabled ifFalse: [ ^ self ].
	self trace: (formatString format: formatArgument)
]

{ #category : #accessing }
WDCEngine >> unsuspendAll [
	frameBufferingDriver ifNotNil: [ frameBufferingDriver unsuspendAll ]
]

{ #category : #'resource loading' }
WDCEngine >> vertexLayoutFor: aVertexClass [
	^ resourceCache vertexLayoutFor: aVertexClass
]

{ #category : #'resource loading' }
WDCEngine >> vertexLayoutForVertexChannelDescriptions: channelDescriptions [
	^ resourceCache vertexLayoutForVertexChannelDescriptions: channelDescriptions
]

{ #category : #accessing }
WDCEngine >> vrSystem [
	^ vrSystem
]
