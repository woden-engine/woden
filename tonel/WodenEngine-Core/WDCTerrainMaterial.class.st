Class {
	#name : #WDCTerrainMaterial,
	#superclass : #WDCMaterial,
	#instVars : [
		'materialState',
		'heightMapTexture',
		'splattingTexture',
		'albedoTextures',
		'normalTextures',
		'resourceBindingsAreUpdated',
		'resourceBinding',
		'stateUniformBuffer',
		'vertexShader',
		'heightMapSize',
		'solidFragmentShader',
		'wireFragmentShader',
		'isolinesFragmentShader',
		'depthNormalFragmentShader',
		'shaderLibrary',
		'metallicRoughnessTextures',
		'triplanar'
	],
	#category : #'WodenEngine-Core-Material'
}

{ #category : #'as yet unclassified' }
WDCTerrainMaterial class >> defaultMetallicFactor [
	^ 0.0
]

{ #category : #'as yet unclassified' }
WDCTerrainMaterial class >> defaultRoughnessFactor [
	^ 0.55
]

{ #category : #rendering }
WDCTerrainMaterial >> activateDepthNormalOn: stateTracker [
	stateTracker objectDepthWriteMask == false ifTrue: [ ^ false ].
	stateTracker hasTerrainDeformationState ifFalse: [ ^ false ].
	
	self validateCache.
	stateTracker
		vertexShader: self vertexShader;
		fragmentShader: self depthNormalFragmentShader.

	"For the height map"		
	resourceBinding ifNotNil: [ 
		stateTracker useShaderResources: resourceBinding.
	].

	^ true
]

{ #category : #rendering }
WDCTerrainMaterial >> activateDepthOnlyOn: stateTracker [
	stateTracker objectDepthWriteMask == false ifTrue: [ ^ false ].
	stateTracker hasTerrainDeformationState ifFalse: [ ^ false ].
	
	self validateCache.
	stateTracker
		vertexShader: self vertexShader;
		fragmentShader: nil.

	"For the height map"		
	resourceBinding ifNotNil: [ 
		stateTracker useShaderResources: resourceBinding.
	].

	^ true
]

{ #category : #rendering }
WDCTerrainMaterial >> activateForwardOn: stateTracker [
	"Do not draw the terrain in editor top views."
	stateTracker hasTerrainDeformationState ifFalse: [ ^ false ].

	self validateCache.
	
	stateTracker
		vertexShader: self vertexShader;
		fragmentShader: self fragmentShader.

	(#(top front side) includes: stateTracker editorViewType) ifTrue: [
		stateTracker
			fragmentShader: self isolinesFragmentShader;
			materialBlendingMode: WDCBlendingMode alphaOver 
	] ifFalse: [
		stateTracker submode == #solid ifTrue: [ 
			stateTracker fragmentShader: self solidFragmentShader.
		].
		stateTracker submode == #wire ifTrue: [
			stateTracker
				materialPolygonMode: AGPU_POLYGON_MODE_LINE;
				materialCullMode: AGPU_CULL_MODE_NONE;
				fragmentShader: self wireFragmentShader.
		].
	].
	
	resourceBinding ifNotNil: [ 
		stateTracker useShaderResources: resourceBinding.
	].
	
	^ true
]

{ #category : #accessing }
WDCTerrainMaterial >> albedoTextures [
	^ albedoTextures
]

{ #category : #accessing }
WDCTerrainMaterial >> albedoTextures: anArray [
	self assert: (anArray isArray and: [ anArray size = 5 ]).
	albedoTextures := anArray
]

{ #category : #'state binding' }
WDCTerrainMaterial >> bindResources [
	| signature resourceCache |
	resourceBinding ifNil: [ 
		signature := WDCSceneRenderingShaderSignature for: engine.
		resourceBinding := signature newMaterialState.
	].

	stateUniformBuffer ifNil: [
		self flag: 'TODO: Use a memory pool here.'.
		stateUniformBuffer := engine createStreamingUniformBuffer: (WDCTerrainMaterialState structureSize alignedTo: 256).
		self uploadMaterialStateData.
	].

	resourceCache := engine resourceCache.
	resourceBinding bind: 0 uniformBuffer: stateUniformBuffer.
	
	0 to: 4 do: [ :i |
		resourceBinding bind: 2 + i texture: (self validAlbedoTexture: i + 1).
	].

	0 to: 4 do: [ :i |
		resourceBinding bind: 7 + i texture: (self validNormalTexture: i + 1).
	].
	
	0 to: 4 do: [ :i |
		resourceBinding bind: 12 + i texture: (self validMetallicRoughnessTexture: i + 1).
	].

]

{ #category : #'terrain mesh building' }
WDCTerrainMaterial >> createTerrainMeshForSceneNode: sceneNode [
	| builder |
	self flag: 'TODO: Support parameterizing this.'.
	builder := WDCTerrainMeshBuilder for: engine.
	self buildTerrainMeshWith: builder.
	
	^ builder mesh
]

{ #category : #shaders }
WDCTerrainMaterial >> depthNormalFragmentShader [
	^ isolinesFragmentShader ifNil: [ isolinesFragmentShader := self shaderLibrary getFragmentStage: #depthNormal_fragment ]
]

{ #category : #shaders }
WDCTerrainMaterial >> fragmentShader [
	^ triplanar
		ifTrue: [ self shaderLibrary getFragmentStage: #forward_triplanarSplatting ]
		ifFalse: [ self shaderLibrary getFragmentStage: #forward_splatting ]
]

{ #category : #initialization }
WDCTerrainMaterial >> initialize [
	heightMapSize := WMVector2F x: 2.0 y: 2.0.
	materialState := WDCTerrainMaterialState new
		albedo: Color white asWMVector4F;
		metallicFactor: self class defaultMetallicFactor;
		roughnessFactor: self class defaultRoughnessFactor;
		
		textureScaleAndOffset: ((SLVMNativeArray for: WMVector4F new: 5) atAllPut: (WMVector4F x: 1.0 y: 1.0));
		yourself.
	albedoTextures := { nil . nil . nil . nil . nil }.
	normalTextures := { nil . nil . nil . nil . nil }.
	metallicRoughnessTextures := { nil . nil . nil . nil . nil }.
	triplanar := false.
	self invalidateCache.
]

{ #category : #initialization }
WDCTerrainMaterial >> invalidateCache [
	resourceBindingsAreUpdated := false.
]

{ #category : #shaders }
WDCTerrainMaterial >> isolinesFragmentShader [
	^ isolinesFragmentShader ifNil: [ isolinesFragmentShader := self shaderLibrary getFragmentStage: #forward_isolines ]
]

{ #category : #accessing }
WDCTerrainMaterial >> localBoundingBox [
	| halfSize heightRange |
	halfSize := heightMapSize*0.5.
	heightRange := self heightRange.
	
	^ WMBox3DF
		nx: halfSize x negated ny: heightRange first nz: halfSize y negated 
		px: halfSize x py: heightRange second pz: halfSize y
]

{ #category : #accessing }
WDCTerrainMaterial >> materialState [
	^ materialState
]

{ #category : #accessing }
WDCTerrainMaterial >> materialState: anObject [
	materialState := anObject
]

{ #category : #accessing }
WDCTerrainMaterial >> normalTextures [
	^ normalTextures
]

{ #category : #accessing }
WDCTerrainMaterial >> normalTextures: anArray [
	self assert: (anArray isArray and: [ anArray size = 5 ]).
	normalTextures := anArray
]

{ #category : #parsing }
WDCTerrainMaterial >> parse: materialFileReference data: data [
	albedoTextures := self parse: data at: materialFileReference srgbTexture: 'albedo-textures' arrayOfSize: 5.
	normalTextures := self parse: data at: materialFileReference texture: 'normal-textures' arrayOfSize: 5.
	metallicRoughnessTextures := self parse: data at: materialFileReference texture: 'metallic-roughness-textures' arrayOfSize: 5.
	triplanar := data at: 'triplanar' ifAbsent: [ false ].

	materialState
		albedo: (self parse: data at: materialFileReference srgbColor: 'albedo-color' ifAbsent: [ Color white ]);
		roughnessFactor: (data at: 'roughness-factor' ifAbsent: [
			metallicRoughnessTextures first
				ifNil: [ self class defaultRoughnessFactor ]
				ifNotNil: [ 1.0 ]
		]);
		metallicFactor: (data at: 'metallic-factor' ifAbsent: [
			metallicRoughnessTextures first
				ifNil: [ self class defaultMetallicFactor ]
				ifNotNil: [ 1.0 ]
		]);
		
		textureScaleAndOffset: (self parse: data at: materialFileReference array: 'texture-scales-offsets' size: 5 nativeType: WMVector4F ifAbsent: [ WMVector4F x: 1.0 y: 1.0 z: 0.0 w: 0.0]).

	self invalidateCache.
]

{ #category : #enumerating }
WDCTerrainMaterial >> precacheResources [
	self shaderLibrary
]

{ #category : #shaders }
WDCTerrainMaterial >> shaderLibrary [
	^ shaderLibrary ifNil: [ shaderLibrary := engine loadShaderLibrary: 'shaders/material/terrain.dastrel' ].

]

{ #category : #shaders }
WDCTerrainMaterial >> solidFragmentShader [
	^ solidFragmentShader ifNil: [ solidFragmentShader := self shaderLibrary getFragmentStage: #forward_solid ].

]

{ #category : #accessing }
WDCTerrainMaterial >> splattingTexture [
	^ splattingTexture
]

{ #category : #accessing }
WDCTerrainMaterial >> splattingTexture: anObject [
	splattingTexture := anObject
]

{ #category : #preview }
WDCTerrainMaterial >> thumbnail [
	heightMapTexture ifNotNil: [ ^ WDCResourceThumbnail type: #terrain value: heightMapTexture thumbnail ].
	splattingTexture ifNotNil: [ ^ WDCResourceThumbnail type: #terrain value: splattingTexture thumbnail ].

	^ WDCResourceThumbnail type: #terrain value: Color brown
]

{ #category : #'state binding' }
WDCTerrainMaterial >> uploadMaterialStateData [
	stateUniformBuffer ifNotNil: [ 
		materialState storeBytesIn: stateUniformBuffer validPointer getHandle.
	]
	
]

{ #category : #'as yet unclassified' }
WDCTerrainMaterial >> validAlbedoTexture: textureIndex [
	^ (albedoTextures at: textureIndex) ifNil: [ engine resourceCache whiteTexture ]
]

{ #category : #'as yet unclassified' }
WDCTerrainMaterial >> validMetallicRoughnessTexture: textureIndex [
	^ (metallicRoughnessTextures at: textureIndex) ifNil: [ engine resourceCache whiteTexture ]
]

{ #category : #'as yet unclassified' }
WDCTerrainMaterial >> validNormalTexture: textureIndex [
	^ (normalTextures at: textureIndex) ifNil: [ engine resourceCache defaultNormalTexture ]
]

{ #category : #'state binding' }
WDCTerrainMaterial >> validateCache [
	resourceBindingsAreUpdated ifFalse: [ self bindResources ].
	resourceBindingsAreUpdated := true.
]

{ #category : #shaders }
WDCTerrainMaterial >> vertexShader [
	^ vertexShader ifNil: [ vertexShader := self shaderLibrary getVertexStage: #vertex ].
]

{ #category : #shaders }
WDCTerrainMaterial >> wireFragmentShader [
	^ wireFragmentShader ifNil: [ wireFragmentShader := self shaderLibrary getFragmentStage: #forward_wire ].

]
