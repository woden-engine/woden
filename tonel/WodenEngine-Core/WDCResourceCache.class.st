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
		'alwaysFrontDepthNormalFragmentShader'
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
				rows: fieldType rows;
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

{ #category : #'lazy resource loading' }
WDCResourceCache >> concretizeSRGBTexture: aTextureDescription [
	^ aTextureDescription concretizeWodenSRGBTextureWithResourceCache: self
]

{ #category : #'lazy resource loading' }
WDCResourceCache >> concretizeTexture: aTextureDescription [
	^ aTextureDescription concretizeWodenTextureWithResourceCache: self
]

{ #category : #private }
WDCResourceCache >> createDefaultMaterial [
	defaultMaterial := WDCGenericSurfaceMaterial for: engine.
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

{ #category : #accessing }
WDCResourceCache >> defaultMaterial [
	defaultMaterial ifNil: [ self createDefaultMaterial ].
	^ defaultMaterial
]

{ #category : #textures }
WDCResourceCache >> defaultNormalTexture [
	^ self getOrCreateColorTexture: (Color r: 0.5 g: 0.5 b: 1.0)
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

{ #category : #'resource loading' }
WDCResourceCache >> getOrCreateColorTexture: aColor [
	^ self resourceAt: aColor -> #colorTexture ifAbsentPut: [ self createTextureWithColor: aColor ].
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
]

{ #category : #'3d models' }
WDCResourceCache >> load3DModel: aFileNameOrReference [
	| modelFile |
	modelFile := self resolveResourceFileReference: aFileNameOrReference.
	^ self resourceAt: modelFile -> #model ifAbsentPut: [ WDCModelLoader loadFromFile: modelFile ].

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
	^ self resourceAt: modelFile -> #mesh ifAbsentPut: [ (self load3DModel: modelFile) meshFor: engine  ].

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
WDCResourceCache >> performLoadTextureDataFile: textureFile withQuery: query [
	| result |
	result := WDCTextureReader loadFromFile: textureFile withQuery: query.
	engine autoReloadChanges ifTrue: [
		PhanideFileSystemMonitor on: textureFile when: PhanideFileEventCloseWrite do: [ :event |
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
		PhanideFileSystemMonitor on: materialFileReference when: PhanideFileEventCloseWrite do: [ :event |
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

{ #category : #'auto reloading' }
WDCResourceCache >> reloadPendingResources [
	| action hasSynchronizedWithGpu |
	hasSynchronizedWithGpu := false.
	[ action := pendingResourceReloadActions nextOrNil ] whileNotNil: [ 
		hasSynchronizedWithGpu ifFalse: [
			engine graphicsQueue finishExecution.
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
WDCResourceCache >> resourceAt: name ifAbsentPut: aBlock [
	| result |
	"Weak GC can also return nil."
	result := resources at: name ifAbsent: [ nil ].
	result ifNotNil: [ ^ result ].

	result := aBlock value.
	resources at: name put: result.
	^ result
]

{ #category : #'special shaders' }
WDCResourceCache >> screenQuadVertexShader [
	^ screenQuadVertexShader ifNil: [ screenQuadVertexShader := self loadVertexShader: 'shaders/vertex/screenQuad.dastrel' ]
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
WDCResourceCache >> whiteTexture [
	^ self getOrCreateColorTexture: Color white
]
