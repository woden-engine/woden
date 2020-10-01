Class {
	#name : #WDCResourceCache,
	#superclass : #Object,
	#instVars : [
		'engine',
		'resources',
		'defaultMaterial',
		'shaderLanguageTarget',
		'shaderLanguageTargetName',
		'shaderSignatures',
		'vertexLayouts',
		'pipelineStates',
		'streamingUniformBufferPools',
		'streamingStorageBufferPools',
		'poolsMutex',
		'pendingResourceReloadActions',
		'screenQuadVertexShader',
		'alwaysFrontDepthNormalFragmentShader',
		'temporaryResourcesMutex',
		'temporaryResourcesDictionary',
		'proceduralMipmapGenerationLibrary',
		'proceduralOfflineTextureRenderer',
		'imageBasedLightingIntegrationLibrary',
		'imageBasedLightingBRDFLut',
		'neutralObjectInstanceState',
		'screenQuadCameraStateBinding'
	],
	#classVars : [
		'ShaderLanguageTargetMap',
		'ShaderStageToName'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Engine'
}

{ #category : #'as yet unclassified' }
WDCResourceCache class >> cachedValueFor: anObjectDescription ifAbsentPut: ifAbsentPutBlock [
	^ self cachedValueFor: anObjectDescription ifPresent: [ :previous | previous ] ifAbsentPut: ifAbsentPutBlock
]

{ #category : #'as yet unclassified' }
WDCResourceCache class >> cachedValueFor: anObjectDescription ifPresent: ifPresentBlock [
	^ self cachedValueFor: anObjectDescription ifPresent: ifPresentBlock ifAbsentPut: [ ^ self ]
]

{ #category : #'as yet unclassified' }
WDCResourceCache class >> cachedValueFor: anObjectDescription ifPresent: ifPresentBlock ifAbsentPut: ifAbsentPutBlock [
	| fileName valueToSave |
	fileName := self fileNameForCachedValue: anObjectDescription.
	fileName exists ifTrue: [ ^ ifPresentBlock value: (FLMaterializer materializeFromFileNamed: fileName fullName)].
	
	valueToSave := ifAbsentPutBlock value.
	FLSerializer serialize: valueToSave toFileNamed: fileName fullName.
	^ valueToSave
]

{ #category : #'as yet unclassified' }
WDCResourceCache class >> fileNameForCachedValue: anObjectDescription [
	^ self proceduralContentDiskCache
		/ ((SHA256 hashMessage: anObjectDescription printString) hex , '.fuel')
]

{ #category : #initialization }
WDCResourceCache class >> initialize [
	ShaderLanguageTargetMap := Dictionary newFromPairs: {
		AGPU_SHADER_LANGUAGE_GLSL . #glsl.
		AGPU_SHADER_LANGUAGE_EGLSL . #eglsl.
		AGPU_SHADER_LANGUAGE_HLSL . #hlsl.
		AGPU_SHADER_LANGUAGE_SPIR_V . #'spir-v'.
    	AGPU_SHADER_LANGUAGE_METAL . #metal.
	}.
	
	ShaderStageToName := Dictionary newFromPairs: { 
		AGPU_VERTEX_SHADER  . #vertex.
		AGPU_FRAGMENT_SHADER  . #fragment.
		AGPU_COMPUTE_SHADER  . #compute.
	}
	
]

{ #category : #'as yet unclassified' }
WDCResourceCache class >> proceduralContentDiskCache [
	| result |
	result := FileSystem workingDirectory / 'procedural-content-cache'.
	result exists ifFalse: [ result createDirectory ].
	^ result
]

{ #category : #adding }
WDCResourceCache >> addedAssetSearchPath: searchPathReference [
	"Nothing to do. My job is lazy"
]

{ #category : #thumbnail }
WDCResourceCache >> allMaterialNames [
	| result materialsSubdir |
	result := OrderedCollection new.
	engine assetSearchPaths do: [ :searchPath |
		materialsSubdir := searchPath / 'materials'.
		materialsSubdir isDirectory ifTrue: [
			result addAll: ((materialsSubdir allChildrenMatching: '*.json') collect: [ :fileRef |
				self stringifyPath: (fileRef relativeToPath: searchPath) ])
		]
	].

	^ result
]

{ #category : #'special shaders' }
WDCResourceCache >> alwaysFrontDepthNormalFragmentShader [
	^ alwaysFrontDepthNormalFragmentShader ifNil: [ alwaysFrontDepthNormalFragmentShader := self loadFragmentShader: 'shaders/rendering/alwaysFrontDepthNormalFragment.dastrel' ]
]

{ #category : #'resource loading' }
WDCResourceCache >> binaryContentsOf: aFileReference [
	^ aFileReference readStreamDo: [ :in |
		^ in binary; upToEnd
	]
]

{ #category : #textures }
WDCResourceCache >> blackCubeMap [
	^ self getOrCreateColorCubeMap: Color black
]

{ #category : #textures }
WDCResourceCache >> blackRGBMCubeMap [
	^ self blackCubeMap
]

{ #category : #textures }
WDCResourceCache >> blackTexture [
	^ self getOrCreateColorTexture: Color black
]

{ #category : #'pipeline states' }
WDCResourceCache >> buildPipelineStateWithDescription: description [
	| result |
	description traceBuildWith: engine.
	result := WDCPipelineState new
		description: description copy;
		device: engine device;
		yourself.
	result build.
	^ result
]

{ #category : #'resource loading' }
WDCResourceCache >> buildVertexLayout: vertexLayout [
	| device attribSize numberOfAttributes dest attrib attributeBuffer fieldType attribBuffer agpuLayout strideBuffer |
	device := engine device.
	
	"Compute the total number of attributes"
	attribSize := AGPUVertexAttribDescription structureSize.
	numberOfAttributes := 0.
	vertexLayout buffers do: [ :buffer |
		numberOfAttributes := numberOfAttributes + buffer fields size.
	].

	"Allocate storage for the attributes"
	attributeBuffer := ByteArray new: numberOfAttributes * attribSize.
	strideBuffer := ByteArray new: vertexLayout buffers size * 4.
	dest := 1.

	"Store the attributes"
	attrib := AGPUVertexAttribDescription new.
	vertexLayout buffers doWithIndex: [ :buffer :i |
		strideBuffer unsignedLongAt: i*4 - 3 put: buffer size.
		buffer fields do: [ :field |
			fieldType := field type.
			attrib
				buffer: i - 1;
				binding: field binding;
				format: fieldType format;
				divisor: 0;
				offset: field offset.

			"Put the structure in the array."
			attribBuffer := attrib getHandle.
			1 to: attribSize do: [ :j |
				attributeBuffer at: dest put: (attribBuffer at: j).
				dest := dest + 1.
			]
		]
	].
	
	agpuLayout := device createVertexLayout.
	agpuLayout addVertexAttributeBindings: vertexLayout buffers size vertex_strides: strideBuffer attribute_count: numberOfAttributes attributes: (AGPUVertexAttribDescription fromHandle: attributeBuffer).
	vertexLayout handle: agpuLayout.

]

{ #category : #'special textures' }
WDCResourceCache >> computeCubeTextureIrradianceMap: cubeTexture [
	| extent resultTextureData shader resultLayer renderer cubeLayers |
	extent := 32@32.
	shader := self imageBasedLightingIntegrationLibrary getFragmentStage: #irradianceMapComputation.
	cubeLayers := (1 to: 6) collect: [ :faceId |
		resultTextureData := WDCTextureData extent: extent bpp: 32 format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM mipmapCount: 1.
		resultLayer := resultTextureData layers first.
	
		renderer := self mainProceduralOfflineTextureRendererForExtent: extent.
		renderer critical: [ 
			renderer renderWith: [ 
				renderer
					cubeFaceId: faceId - 1;
					proceduralTextureRendererInputTextures: { cubeTexture };
					renderProceduralTextureWithFragmentShader: shader extent: extent format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM;
					generateProceduralTextureWithExtent: extent fetchWith: #fetch_texture mipmapWith: #mipmap encodeWith: #encode_bgra8 for: resultLayer
			];
			submit;
			finish;
			readMipmapLevelsInto: resultLayer
		].
		resultLayer
	].

	resultTextureData
		type: AGPU_TEXTURE_CUBE;
		layers: cubeLayers.
	^ resultTextureData
]

{ #category : #'special textures' }
WDCResourceCache >> computeCubeTextureSpecularMap: cubeTexture [
	| extent resultTextureData shader resultLayer renderer cubeLayers |
	extent := 128@128.
	shader := self imageBasedLightingIntegrationLibrary getFragmentStage: #specularIrradianceMapComputation.
	cubeLayers := (1 to: 6) collect: [ :faceId |
		resultTextureData := WDCTextureData extent: extent bpp: 32 format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM mipmapCount: 1.
		resultLayer := resultTextureData layers first.
	
		renderer := self mainProceduralOfflineTextureRendererForExtent: extent.
		renderer critical: [ 
			renderer renderWith: [ 
				renderer
					cubeFaceId: faceId - 1;
					proceduralTextureRendererInputTextures: { cubeTexture };
					renderProceduralTextureMipmapsWithFragmentShader: shader extent: extent format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM encodeWith: #encode_bgra8 intoTextureLayerData: resultLayer
			];
			submit;
			finish;
			readMipmapLevelsInto: resultLayer
		].
		resultLayer
	].

	resultTextureData
		type: AGPU_TEXTURE_CUBE;
		layers: cubeLayers.
	^ resultTextureData
]

{ #category : #'special textures' }
WDCResourceCache >> computeEnvironmentLightProbeFromCubeTexture: cubeTexture [
	| irradianceTextureData irradianceTexture specularTextureData specularTexture |
	irradianceTextureData := self computeCubeTextureIrradianceMap: cubeTexture.
	irradianceTexture := irradianceTextureData asTextureFor: engine.

	specularTextureData := self computeCubeTextureSpecularMap: cubeTexture.
	specularTexture := specularTextureData asTextureFor: engine.
	^ WDCEnvironmentLightingProbe new
		diffuseIrradianceMap: irradianceTexture;
		specularIrradianceMap: specularTexture;
		yourself
]

{ #category : #'special textures' }
WDCResourceCache >> computeImageBasedLightingBRDFLut [
	<script: 'WDCEngine default resourceCache computeImageBasedLightingBRDFLut inspect'>
	| extent resultTextureData shader resultLayer renderer |
	extent := 512@512.
	shader := self imageBasedLightingIntegrationLibrary getFragmentStage: #brdfLutComputation.
	resultTextureData := WDCTextureData extent: extent bpp: 32 format: AGPU_TEXTURE_FORMAT_R16G16_UNORM mipmapCount: 1.
	resultLayer := resultTextureData layers first.
	
	renderer := self mainProceduralOfflineTextureRendererForExtent: extent.
	renderer critical: [ 
		renderer renderWith: [ 
			renderer
				renderProceduralTextureWithFragmentShader: shader extent: extent format: AGPU_TEXTURE_FORMAT_R16G16_UNORM;
				generateProceduralTextureWithExtent: extent fetchWith: #fetch_texture mipmapWith: #mipmap encodeWith: #encode_r16g16 for: resultLayer
		];
		submit;
		finish;
		readMipmapLevelsInto: resultLayer
	].

	^ resultTextureData
]

{ #category : #'lazy resource loading' }
WDCResourceCache >> concretizeSRGBTexture: aTextureDescription [
	^ aTextureDescription concretizeWodenSRGBTextureWithResourceCache: self
]

{ #category : #'lazy resource loading' }
WDCResourceCache >> concretizeTexture: aTextureDescription [
	^ aTextureDescription concretizeWodenTextureWithResourceCache: self
]

{ #category : #textures }
WDCResourceCache >> createCubeTextureWithColor: aColor [
	| level layer textureData |
	level := WDCTextureLevelData new
		width: 1; height: 1; depth: 1; pitch: 4; slicePitch:4;
		data: (ByteArray new: 4);
		colorRenderWith: [ :x :y | aColor ];
		yourself.
	layer := WDCTextureLayerData new width: 1; height: 1; depth: 1; levels: { level }; yourself.
	textureData := WDCTextureData new
		type: AGPU_TEXTURE_CUBE;
		pixelFormat: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM;
		srgbPixelFormat: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB;
		miplevels: 1;
		width: 1;
		height: 1;
		depth: 1;
		layers: ((1 to: 6) collect: [ :i | layer ]);
		yourself.
		
	^ textureData asSRGBTextureFor: engine 
]

{ #category : #private }
WDCResourceCache >> createDefaultMaterial [
	defaultMaterial := WDCMetallicRoughnessMaterial for: engine.
]

{ #category : #textures }
WDCResourceCache >> createOnePixelFormWith: aColor [
	^ (Form extent: 1@1 depth: 32)
		fillColor: aColor;
		yourself
]

{ #category : #textures }
WDCResourceCache >> createSRGBTextureWithColor: aColor [
	^ self createSRGBTextureWithForm: (self createOnePixelFormWith: aColor)
]

{ #category : #textures }
WDCResourceCache >> createSRGBTextureWithForm: aForm [
	^ aForm asSRGBTextureFor: engine
]

{ #category : #textures }
WDCResourceCache >> createTextureWithColor: aColor [
	^ self createTextureWithForm: (self createOnePixelFormWith: aColor)
]

{ #category : #textures }
WDCResourceCache >> createTextureWithForm: aForm [
	^ aForm asTextureFor: engine
]

{ #category : #'resource loading' }
WDCResourceCache >> createVertexLayoutForChannelDescriptions: channelDescriptions [
	| layout |
	layout := WDCVertexLayout new buffers: (channelDescriptions collect: #asWodenVertexStructureDescription).
	self buildVertexLayout: layout.
	^ layout
]

{ #category : #'special shaders' }
WDCResourceCache >> cubeScreenQuadVertexShader [
	| shaderLibrary |
	^ screenQuadVertexShader ifNil: [
		shaderLibrary := self loadShaderLibrary: 'shaders/vertex/cubeScreenQuad.dastrel'.
		engine projectionInvertedY
			ifTrue: [ shaderLibrary getVertexStage: 'screenQuad' ]
			ifFalse: [ shaderLibrary getVertexStage: 'screenQuadFlippedY' ]
	]
]

{ #category : #accessing }
WDCResourceCache >> defaultMaterial [
	defaultMaterial ifNil: [ self createDefaultMaterial ].
	^ defaultMaterial
]

{ #category : #textures }
WDCResourceCache >> defaultNormalTexture [
	^ self getOrCreateColorTexture: (Color r: 0.0 g: 0.5 b: 1.0 alpha: 0.5)
]

{ #category : #materials }
WDCResourceCache >> doActualMaterialLoading: materialFileReference [
	| materialData materialType materialClassName materialClass |
	materialData := NeoJSONReader fromString: materialFileReference contents.
	materialType := materialData at: 'type' ifAbsent: [
		self error: 'Material does not have a valid type.'
	].

	materialClassName := ('WDC' , materialType , 'Material') asSymbol.
	materialClass := Smalltalk at: materialClassName ifAbsent: [ self error: 'Failed to find material class for material type ' , materialType ].
	self assert: materialClass isMaterialClass.
	^ (materialClass for: engine)
		parse: materialFileReference data: materialData;
		yourself
]

{ #category : #accessing }
WDCResourceCache >> engine [
	^ engine
]

{ #category : #'auto reloading' }
WDCResourceCache >> enqueueResourceReloadAction: aBlock [
	pendingResourceReloadActions nextPut: aBlock
]

{ #category : #thumbnail }
WDCResourceCache >> ensureAllMaterialThumbnailsInDB: thumbnailDB [
	self allMaterialNames do: [ :materialName |
		thumbnailDB thumbnailFor: materialName ifAbsentPut: [
			(self loadMaterial: materialName) thumbnail
		]
	]
]

{ #category : #accessing }
WDCResourceCache >> flatColorMaterial [
	^ self loadMaterial: 'materials/basic/flat.json'
]

{ #category : #'memory pools' }
WDCResourceCache >> genericObjectStatePool [
	^ self streamingUniformBufferPoolFor: WDCGenericObjectState
]

{ #category : #'resource loading' }
WDCResourceCache >> getNamedRenderTargetTexture: name ifAbsent: aBlock [

	^ self resourceAt: name -> #renderTargetTexture ifAbsent: aBlock.
]

{ #category : #'resource loading' }
WDCResourceCache >> getOrCreateColorCubeMap: aColor [
	^ self resourceAt: aColor -> #colorCubeTexture ifAbsentPut: [ self createCubeTextureWithColor: aColor ].
]

{ #category : #'resource loading' }
WDCResourceCache >> getOrCreateColorTexture: aColor [
	^ self resourceAt: aColor -> #colorTexture ifAbsentPut: [ self createTextureWithColor: aColor ].
]

{ #category : #'resource loading' }
WDCResourceCache >> getOrCreateNamedRenderTargetTexture: name withExtent: extent pixelFormat: pixelFormat [

	^ self resourceAt: name -> #renderTargetTexture ifAbsentPut: [ engine createRenderTargetColorTextureWithExtent: extent format: pixelFormat ].
]

{ #category : #'resource loading' }
WDCResourceCache >> getOrCreateSRGBColorTexture: aColor [
	^ self resourceAt: aColor -> #srgbColorTexture ifAbsentPut: [ self createSRGBTextureWithColor: aColor ].
]

{ #category : #accessing }
WDCResourceCache >> getOrCreateShaderSignature: aShaderSignatureClass [
	| instance |
	^ shaderSignatures at: aShaderSignatureClass ifAbsentPut: [
		instance := aShaderSignatureClass new engine: engine.
		instance handle: (instance createHandleForDevice: engine device).
		instance
	]
]

{ #category : #textures }
WDCResourceCache >> grayTextureExtent: extent renderWith: aBlock [
	| data |
	data := WDCTextureData extent: extent grayRenderWith: aBlock.
	^ data asTextureFor: engine
]

{ #category : #'special textures' }
WDCResourceCache >> imageBasedLightingBRDFLut [
	^ imageBasedLightingBRDFLut ifNil: [ imageBasedLightingBRDFLut :=  self imageBasedLightingBRDFLutData asTextureFor: engine ]
]

{ #category : #'special textures' }
WDCResourceCache >> imageBasedLightingBRDFLutData [
	^ self computeImageBasedLightingBRDFLut
]

{ #category : #'special shaders' }
WDCResourceCache >> imageBasedLightingIntegrationLibrary [
	^ imageBasedLightingIntegrationLibrary ifNil: [
		imageBasedLightingIntegrationLibrary := self loadShaderLibrary: 'shaders/lighting/ibl-integration.dastrel'.
	]
]

{ #category : #initialization }
WDCResourceCache >> initializeForEngine: anEngine [
	engine := anEngine.
	resources := WeakValueDictionary new.
	shaderSignatures := IdentityDictionary new.
	vertexLayouts := IdentityDictionary new.
	pipelineStates := Dictionary new.
	
	poolsMutex := Semaphore forMutualExclusion.
	streamingUniformBufferPools := IdentityDictionary new.
	streamingStorageBufferPools := IdentityDictionary new.

	shaderLanguageTarget := engine device getPreferredIntermediateShaderLanguage.
	shaderLanguageTarget = AGPU_SHADER_LANGUAGE_NONE ifTrue: [ 
		shaderLanguageTarget := engine device getPreferredHighLevelShaderLanguage.
		shaderLanguageTarget = AGPU_SHADER_LANGUAGE_NONE ifTrue: [
			shaderLanguageTarget := engine device getPreferredShaderLanguage
		].
	].

	shaderLanguageTargetName := ShaderLanguageTargetMap at: shaderLanguageTarget.
	pendingResourceReloadActions := WaitfreeQueue new.
	
	temporaryResourcesMutex := Semaphore forMutualExclusion.
	temporaryResourcesDictionary := Dictionary new.
	
]

{ #category : #'3d models' }
WDCResourceCache >> load3DModel: aFileNameOrReference [
	| modelFile |
	modelFile := self resolveResourceFileReference: aFileNameOrReference.
	^ self resourceAt: modelFile -> #model ifAbsentPut: [ WDCAbstractModelLoader loadFromFile: modelFile ].

]

{ #category : #shaders }
WDCResourceCache >> loadComputeShader: aFileNameOrReference [
	^ self loadComputeShader: aFileNameOrReference entryPoint: #main
]

{ #category : #shaders }
WDCResourceCache >> loadComputeShader: aFileNameOrReference entryPoint: entryPointName [
	^ (self loadShaderLibrary: aFileNameOrReference)
		getComputeStage: entryPointName
]

{ #category : #shaders }
WDCResourceCache >> loadFragmentShader: aFileNameOrReference [
	^ self loadFragmentShader: aFileNameOrReference entryPoint: #main
]

{ #category : #shaders }
WDCResourceCache >> loadFragmentShader: aFileNameOrReference entryPoint: entryPointName [
	^ (self loadShaderLibrary: aFileNameOrReference)
		getFragmentStage: entryPointName
]

{ #category : #shaders }
WDCResourceCache >> loadLowLevelShaderCode: aFileNameOrReference [
	| shaderFile |
	shaderFile := self resolveResourceFileReference: aFileNameOrReference.
	^ self resourceAt: shaderFile -> #lowLevelShader ifAbsentPut: [ self performLowLevelShaderLoading: shaderFile ].
]

{ #category : #materials }
WDCResourceCache >> loadMaterial: aFileNameOrReference [
	| materialFile |
	materialFile := self resolveResourceFileReference: aFileNameOrReference.
	^ self resourceAt: materialFile -> #material ifAbsentPut: [
		self performMaterialLoading: materialFile
	].

]

{ #category : #materials }
WDCResourceCache >> loadMaterial: aFileNameOrReference fallback: aBlock [
	| materialFile |
	materialFile := self resolveResourceFileReference: aFileNameOrReference ifFailed: [ ^ aBlock value ].
	^ self resourceAt: materialFile -> #material ifAbsentPut: [ self performMaterialLoading: materialFile ].

]

{ #category : #'3d models' }
WDCResourceCache >> loadMesh: aFileNameOrReference [
	| modelFile |
	modelFile := self resolveResourceFileReference: aFileNameOrReference.
	^ (self resourceAt: modelFile -> #mesh ifAbsentPut: [ (self load3DModel: modelFile) meshFor: engine  ])
	copyForResourceCacheInstancing.

]

{ #category : #'resource loading' }
WDCResourceCache >> loadSRGBTexture: aFileNameOrReference [
	| textureFile |
	textureFile := self resolveResourceFileReferenceWithQuery: aFileNameOrReference.
	^ self resourceAt: textureFile -> #srgbTexture ifAbsentPut: [ (self loadTextureData: textureFile) asSRGBTextureFor: engine ].
]

{ #category : #shaders }
WDCResourceCache >> loadShaderLibrary: aFileNameOrReference [
	| shaderFile |
	shaderFile := self resolveResourceFileReference: aFileNameOrReference.
	^ self resourceAt: shaderFile -> #shaderLibrary ifAbsentPut: [ self performShaderLibraryLoading: shaderFile ].
]

{ #category : #'resource loading' }
WDCResourceCache >> loadSoundSample: aFileNameOrReference [
	| sampleFile |
	sampleFile := self resolveResourceFileReference: aFileNameOrReference.
	^ self resourceAt: sampleFile -> #soundSample ifAbsentPut: [ (self loadSoundSampleData: aFileNameOrReference) asSoundSampleFor: engine ].
]

{ #category : #'resource loading' }
WDCResourceCache >> loadSoundSampleData: aFileNameOrReference [
	| sampleDataFile |
	sampleDataFile := self resolveResourceFileReference: aFileNameOrReference.
	^ self resourceAt: sampleDataFile -> #soundSampleData ifAbsentPut: [ WDCWaveFile loadFromFileNamed: sampleDataFile ].
]

{ #category : #'resource loading' }
WDCResourceCache >> loadTerrain: aFileNameOrReference [
	| terrainFile |
	terrainFile := self resolveResourceFileReference: aFileNameOrReference.
	^ self resourceAt: terrainFile -> #texture ifAbsentPut: [
		| terrainData |
		terrainData := self performLoadTerrainDataFile: terrainFile.
		engine autoReloadChanges ifTrue: [
			OSIOFileSystemMonitor on: terrainFile when: OSIOFileEventCloseWrite do: [ :event |
				self enqueueResourceReloadAction: [
					| reloadedTerrain |
					reloadedTerrain := self performLoadTerrainDataFile: terrainFile.
					terrainData reloadReplacement: reloadedTerrain
				]
			].
		].
		
		terrainData
	].

]

{ #category : #'resource loading' }
WDCResourceCache >> loadTexture: aFileNameOrReference [
	| textureFile |
	textureFile := self resolveResourceFileReferenceWithQuery: aFileNameOrReference.
	^ self resourceAt: textureFile -> #texture ifAbsentPut: [ (self loadTextureData: textureFile) asTextureFor: engine ].

]

{ #category : #'resource loading' }
WDCResourceCache >> loadTextureData: aFileNameOrReference [
	| textureFileAndQuery |
	textureFileAndQuery := self resolveResourceFileReferenceWithQuery: aFileNameOrReference.
	^ self resourceAt: textureFileAndQuery -> #textureData ifAbsentPut: [
		self performLoadTextureDataFile: textureFileAndQuery first withQuery: textureFileAndQuery second
	]
]

{ #category : #'resource loading' }
WDCResourceCache >> loadVertexLayoutFrom: aVertexClass [
	| layout |
	layout := aVertexClass asWodenVertexLayout.
	self buildVertexLayout: layout.
	^ layout
]

{ #category : #shaders }
WDCResourceCache >> loadVertexShader: aFileNameOrReference [
	^ self loadVertexShader: aFileNameOrReference entryPoint: #main
]

{ #category : #shaders }
WDCResourceCache >> loadVertexShader: aFileNameOrReference entryPoint: entryPointName [
	^ (self loadShaderLibrary: aFileNameOrReference)
		getVertexStage: entryPointName
]

{ #category : #'temporary resources' }
WDCResourceCache >> mainProceduralOfflineTextureRendererForExtent: anExtent [
	| newWidth newHeight |
	(proceduralOfflineTextureRenderer isNil or:
	[ proceduralOfflineTextureRenderer bufferExtent x < anExtent x or: 
	[ proceduralOfflineTextureRenderer bufferExtent y < anExtent y ]]) ifTrue: [ 
		newWidth := anExtent x asLargerPowerOfTwo.
		newHeight := anExtent y asLargerPowerOfTwo.
		proceduralOfflineTextureRenderer := WDCProceduralOfflineTextureRenderer for: engine extent: newWidth @ newHeight
	].

	^ proceduralOfflineTextureRenderer 
]

{ #category : #'memory pools' }
WDCResourceCache >> neutralGenericObjectInstanceState [
	neutralObjectInstanceState ifNil: [
		neutralObjectInstanceState := (self streamingStorageBufferPoolFor: WDCGenericObjectState) allocate.
		neutralObjectInstanceState value: WDCGenericObjectState neutralState
	].
	^ neutralObjectInstanceState
]

{ #category : #private }
WDCResourceCache >> parseQuery: queryString [
	| query in |
	query := OrderedDictionary new.
	
	in := queryString readStream.
	[in atEnd] whileFalse: [
		(self parseQueryElement: in) ifNotNil: [ :element |
			query add: element
		].
	].
	^ query
]

{ #category : #private }
WDCResourceCache >> parseQueryElement: in [
	| key value |
	key := self parseQueryTerm: in.
	value := nil.
	in peek = $= ifTrue: [
		in next.
		value := self parseQueryTerm: in
	].
	
	in peek = $& ifTrue: [ in next ].
	^ key -> value
]

{ #category : #private }
WDCResourceCache >> parseQueryTerm: in [
	| c |
	^ ByteString streamContents: [ :out |
		[in atEnd not and: [in peek ~= $& and: [in peek ~= $=] ]] whileTrue: [
			c := in next.
			c = $+ ifTrue: [
				out space
			] ifFalse: [
				c = $% ifTrue: [
					out nextPut: (Integer readFrom: (in next: 2) base: 16) asCharacter.
				] ifFalse: [
					out nextPut: c
				] 
			]
		]
	]
]

{ #category : #'resource loading' }
WDCResourceCache >> performLoadTerrainDataFile: terrainFile [
	| script scriptEvaluatorClass terrainData |
	script := terrainFile contents.
	scriptEvaluatorClass := WDCPharoProceduralScriptEvaluator.
	(script beginsWith: '"!GPU') ifTrue: [ 
		scriptEvaluatorClass := WDCPharoProceduralGPUScriptEvaluator
	].

	terrainData := self class cachedValueFor: { #stterrainEval . terrainFile fullName. '|' . script } ifAbsentPut: [Smalltalk compiler
		receiver: (WDCPharoProceduralScriptContext new
			textureGenerator: (scriptEvaluatorClass new
				parameters: (Dictionary newFromPairs: #(texture terrainData));
				yourself)
			);
		evaluate: script
	].
		
	terrainData engine: engine.	
	^ terrainData

]

{ #category : #'resource loading' }
WDCResourceCache >> performLoadTextureDataFile: textureFile withQuery: query [
	| result |
	result := WDCTextureReader loadFromFile: textureFile withQuery: query.
	engine autoReloadChanges ifTrue: [
		OSIOFileSystemMonitor on: textureFile when: OSIOFileEventCloseWrite do: [ :event |
			self enqueueResourceReloadAction: [
				| reloadedTexture |
				reloadedTexture := WDCTextureReader loadFromFile: textureFile withQuery: query.
				result reloadReplacement: reloadedTexture
			]
		].
	].

	^ result
]

{ #category : #shaders }
WDCResourceCache >> performLowLevelShaderLoading: shaderFile [
	| lowLevelShaderSource |
	lowLevelShaderSource := WDCLowLevelShaderSource new
		engine: engine;
		target: shaderLanguageTargetName;
		entryFile: shaderFile.
	lowLevelShaderSource compile.
	
	^ lowLevelShaderSource
	
]

{ #category : #materials }
WDCResourceCache >> performMaterialLoading: materialFileReference [
	| material |
	material := self doActualMaterialLoading: materialFileReference.
	engine autoReloadChanges ifTrue: [
		OSIOFileSystemMonitor on: materialFileReference when: OSIOFileEventCloseWrite do: [ :event |
			self enqueueResourceReloadAction: [
				| reloadedMaterial |
				reloadedMaterial := self doActualMaterialLoading: materialFileReference.
				material reloadReplacement: reloadedMaterial
			]
		].
	].

	^ material
]

{ #category : #shaders }
WDCResourceCache >> performShaderLibraryLoading: shaderFile [
	| source |
	source := self loadLowLevelShaderCode: shaderFile.
	^ source asShaderLibrary

]

{ #category : #'pipeline states' }
WDCResourceCache >> pipelineStateForDescription: description [
	| pso |
	pipelineStates at: description ifPresent: [ :existent | ^ existent ].
	
	pso := self buildPipelineStateWithDescription: description.
	pipelineStates at: pso description put: pso.
	^ pso
]

{ #category : #'special shaders' }
WDCResourceCache >> proceduralMipmapGenerationLibrary [
	^ proceduralMipmapGenerationLibrary ifNil: [ proceduralMipmapGenerationLibrary := self loadShaderLibrary: 'shaders/compute/mipmapGeneration.dastrel' ]
]

{ #category : #'auto reloading' }
WDCResourceCache >> reloadPendingResources [
	| action hasSynchronizedWithGpu |
	hasSynchronizedWithGpu := false.
	[ action := pendingResourceReloadActions nextOrNil ] whileNotNil: [ 
		hasSynchronizedWithGpu ifFalse: [
			engine device finishExecution.
			hasSynchronizedWithGpu := true
		].
	
		[
			action value
		] on: Error do: [ :e |
			e freeze.
			[ e debug ] fork
		]
	]
]

{ #category : #private }
WDCResourceCache >> resolveResourceFileReference: aFileName [
	^ self resolveResourceFileReference: aFileName ifFailed: [
		self error: 'Failed to solve resource path ', aFileName printString
	]
]

{ #category : #private }
WDCResourceCache >> resolveResourceFileReference: aFileName ifFailed: aBlock [
	| fileReference solvedReference |
	(aFileName isString and: [ aFileName isEmpty ]) ifTrue: [ ^ aBlock value ].

	fileReference := aFileName asFileReference.
	fileReference exists ifTrue: [ ^ fileReference asAbsolute ].
	engine assetSearchPaths do: [ :searchPath |
		solvedReference := searchPath resolve: fileReference.
		solvedReference exists ifTrue: [ ^ solvedReference asAbsolute ]
	].

	aBlock value.
]

{ #category : #private }
WDCResourceCache >> resolveResourceFileReferenceWithQuery: aFileName [
	| questionMarkIndex  pathPart query |
	aFileName isString ifFalse: [
		aFileName isArray ifTrue: [ ^ aFileName ].
		^ { self resolveResourceFileReference: aFileName . nil }
	].
	
	questionMarkIndex := aFileName indexOf: $? ifAbsent: [
		^ { self resolveResourceFileReference: aFileName . nil }
	].

	pathPart := aFileName copyFrom: 1 to: questionMarkIndex - 1.
	query := self parseQuery: (aFileName copyFrom: questionMarkIndex + 1 to: aFileName size).
	^ { self resolveResourceFileReference: pathPart . query }
]

{ #category : #'resource loading' }
WDCResourceCache >> resourceAt: name ifAbsent: aBlock [
	| result |
	"Weak GC can also return nil."
	result := resources at: name ifAbsent: [ nil ].
	result ifNotNil: [ ^ result ].
	^ aBlock value
]

{ #category : #'resource loading' }
WDCResourceCache >> resourceAt: name ifAbsentPut: aBlock [
	| result |
	"Weak GC can also return nil."
	result := resources at: name ifAbsent: [ nil ].
	result ifNotNil: [ ^ result ].

	result := aBlock value.
	resources at: name put: result.
	^ result
]

{ #category : #accessing }
WDCResourceCache >> screenQuadCameraStateBinding [
	| camerateStateBuffer |
	screenQuadCameraStateBinding ifNotNil: [ ^ screenQuadCameraStateBinding ].
	camerateStateBuffer := (self streamingUniformBufferPoolFor: WDCCameraState) allocate.
	camerateStateBuffer value: (
		WDCCameraState new
			transform: WMReversibleAffineTransformF identity;
			projectionMatrix: (WMMatrix4F
				reverseDepthOrthoLeft: -1.0 right: 1.0 bottom: -1.0
					top: 1.0 near: -1.0 far: 10000.0 invertedY: engine projectionInvertedY);
			exposure: 1.0).
			
	screenQuadCameraStateBinding := (WDCSceneRenderingShaderSignature for: engine)
		newCameraState.
	screenQuadCameraStateBinding bind: 0 uniformBufferElement: camerateStateBuffer.
	^ screenQuadCameraStateBinding
]

{ #category : #'special shaders' }
WDCResourceCache >> screenQuadVertexShader [
	| shaderLibrary |
	^ screenQuadVertexShader ifNil: [
		shaderLibrary := self loadShaderLibrary: 'shaders/vertex/screenQuad.dastrel'.
		engine projectionInvertedY
			ifTrue: [ shaderLibrary getVertexStage: 'screenQuad' ]
			ifFalse: [ shaderLibrary getVertexStage: 'screenQuadFlippedY' ]
	]
]

{ #category : #'session management' }
WDCResourceCache >> sessionChanged [
]

{ #category : #'memory pools' }
WDCResourceCache >> streamingStorageBufferPoolFor: aClass [
	poolsMutex critical: [ 
		^ streamingStorageBufferPools at: aClass ifAbsentPut: [ WDCStreamingStorageBufferPool engine: engine elementType: aClass ]
	]

]

{ #category : #'memory pools' }
WDCResourceCache >> streamingUniformBufferPoolFor: aClass [
	poolsMutex critical: [ 
		^ streamingUniformBufferPools at: aClass ifAbsentPut: [ WDCStreamingUniformBufferPool engine: engine elementType: aClass ]
	]
]

{ #category : #private }
WDCResourceCache >> stringifyPath: aPath [
	| first |
	first := true.
	^ String streamContents: [ :out |
		aPath do: [ :component |
			first ifFalse: [ out nextPut: $/ ].
			first := false.
			out nextPutAll: component
		]
	]
]

{ #category : #'resource loading' }
WDCResourceCache >> vertexLayoutFor: aVertexClass [
	^ vertexLayouts at: aVertexClass ifAbsentPut: [ self loadVertexLayoutFrom: aVertexClass ]
]

{ #category : #'resource loading' }
WDCResourceCache >> vertexLayoutForVertexChannelDescriptions: channelDescriptions [
	^ vertexLayouts at: channelDescriptions ifAbsentPut: [ self createVertexLayoutForChannelDescriptions: channelDescriptions ]
]

{ #category : #textures }
WDCResourceCache >> whiteCubeMap [
	^ self getOrCreateColorCubeMap: Color white
]

{ #category : #textures }
WDCResourceCache >> whiteRGBMCubeMap [
	^ self getOrCreateColorCubeMap: (Color white alpha: 1/255.0)
]

{ #category : #textures }
WDCResourceCache >> whiteTexture [
	^ self getOrCreateColorTexture: Color white
]
