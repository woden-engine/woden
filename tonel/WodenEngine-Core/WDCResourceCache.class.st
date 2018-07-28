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
		'poolsMutex'
	],
	#classVars : [
		'ShaderLanguageTargetMap'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : 'WodenEngine-Core-Engine'
}

{ #category : #initialization }
WDCResourceCache class >> initialize [
	ShaderLanguageTargetMap := Dictionary newFromPairs: {
		AGPU_SHADER_LANGUAGE_GLSL . #glsl.
		AGPU_SHADER_LANGUAGE_EGLSL . #eglsl.
		AGPU_SHADER_LANGUAGE_HLSL . #hlsl.
		AGPU_SHADER_LANGUAGE_SPIR_V . #'spir-v'.
    	AGPU_SHADER_LANGUAGE_METAL . #metal.
	}.
	
]

{ #category : #adding }
WDCResourceCache >> addedAssetSearchPath: searchPathReference [
	"Nothing to do. My job is lazy"
]

{ #category : #'resource loading' }
WDCResourceCache >> binaryContentsOf: aFileReference [
	^ aFileReference readStreamDo: [ :in |
		^ in binary; upToEnd
	]
]

{ #category : #'pipeline states' }
WDCResourceCache >> buildPipelineStateWithDescription: description [
	| handle result |
	engine trace: 'Build PSO vertex: {1} fragment {2}.' format: {description vertexShader asString . description fragmentShader asString}.
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

{ #category : #private }
WDCResourceCache >> createDefaultMaterial [
	defaultMaterial := WDCGenericSurfaceMaterial for: engine.
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

{ #category : #accessing }
WDCResourceCache >> flatColorMaterial [
	^ self loadMaterial: 'materials/basic/flat.json'
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
]

{ #category : #'3d models' }
WDCResourceCache >> load3DModel: aFileNameOrReference [
	| modelFile |
	modelFile := self resolveResourceFileReference: aFileNameOrReference.
	^ self resourceAt: modelFile -> #model ifAbsentPut: [ self perform3DModelLoading: modelFile ].

]

{ #category : #shaders }
WDCResourceCache >> loadFragmentShader: aFileNameOrReference [
	| shaderFile |
	shaderFile := self resolveResourceFileReference: aFileNameOrReference.
	^ self resourceAt: shaderFile -> #fragmentShader ifAbsentPut: [ self performShaderLoading: shaderFile stage: AGPU_FRAGMENT_SHADER ].
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
	^ self resourceAt: materialFile -> #material ifAbsentPut: [ self performMaterialLoading: materialFile ].

]

{ #category : #materials }
WDCResourceCache >> loadMaterial: aFileNameOrReference fallback: aBlock [
	| materialFile |
	materialFile := self resolveResourceFileReference: aFileNameOrReference ifFailed: [ ^ aBlock value ].
	^ self resourceAt: materialFile -> #material ifAbsentPut: [ self performMaterialLoading: materialFile ].

]

{ #category : #'resource loading' }
WDCResourceCache >> loadSRGBTexture: aFileNameOrReference [
	| textureFile |
	textureFile := self resolveResourceFileReference: aFileNameOrReference.
	^ self resourceAt: textureFile -> #srgbTexture ifAbsentPut: [ (self loadTextureData: textureFile) asSRGBTextureFor: engine ].
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
	textureFile := self resolveResourceFileReference: aFileNameOrReference.
	^ self resourceAt: textureFile -> #texture ifAbsentPut: [ (self loadTextureData: textureFile) asTextureFor: engine ].

]

{ #category : #'resource loading' }
WDCResourceCache >> loadTextureData: aFileNameOrReference [
	| textureFile extension |
	textureFile := self resolveResourceFileReference: aFileNameOrReference.
	extension := textureFile extension.
	extension = 'dds' ifTrue: [ ^ WDCDDSTextureReader textureFromFileNamed: textureFile].
	^ ImageReadWriter formFromFileNamed: textureFile
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
	| shaderFile |
	shaderFile := self resolveResourceFileReference: aFileNameOrReference.
	^ self resourceAt: shaderFile -> #vertexShader ifAbsentPut: [ self performShaderLoading: shaderFile stage: AGPU_VERTEX_SHADER ].
]

{ #category : #'3d models' }
WDCResourceCache >> perform3DModelLoading: modelFileReference [
	| extension |
	extension := modelFileReference extension.
	extension = 'fmdl' ifTrue: [ ^ FLMaterializer materializeFromByteArray: (self binaryContentsOf: modelFileReference) ].
	extension = 'wmjson' ifTrue: [ ^ WDCModelImporter new importFromFileNamed: modelFileReference ].
	self error: 'Unsupported model format.'
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

{ #category : #shaders }
WDCResourceCache >> performShaderLoading: shaderFile stage: stageIdentifier [
	| source stage |
	source := self loadLowLevelShaderCode: shaderFile.

	stage := WDCShaderStage new
		engine: engine;
		stage: stageIdentifier;
		shaderLanguageTarget: shaderLanguageTarget;
		source: source;
		yourself.
	stage compile.
	
	source addStage: stage.
	^ stage
]

{ #category : #'pipeline states' }
WDCResourceCache >> pipelineStateForDescription: description [
	| pso |
	pipelineStates at: description ifPresent: [ :existent | ^ existent ].
	
	pso := self buildPipelineStateWithDescription: description.
	pipelineStates at: pso description put: pso.
	^ pso
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
