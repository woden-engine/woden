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
		'fragmentShader'
	],
	#category : #'WodenEngine-Core-Material'
}

{ #category : #rendering }
WDCTerrainMaterial >> activateForwardOn: stateTracker [
	self validateCache.
	
	stateTracker
		vertexShader: vertexShader;
		fragmentShader: fragmentShader.
	
	resourceBinding ifNotNil: [ 
		stateTracker useShaderResources: resourceBinding.
	].
	
	^ true
]

{ #category : #rendering }
WDCTerrainMaterial >> activateShadowOn: stateTracker [
	self validateCache.
	stateTracker
		vertexShader: vertexShader;
		fragmentShader: nil.

	"For the height map"		
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
		signature := WDCForwardRenderingShaderSignature for: engine.
		resourceBinding := signature newMaterialState.
	].

	stateUniformBuffer ifNil: [
		self flag: 'TODO: Use a memory pool here.'.
		stateUniformBuffer := engine createStreamingUniformBuffer: (WDCTerrainMaterialState structureSize alignedTo: 256).
		self uploadMaterialStateData.
	].

	resourceCache := engine resourceCache.
	resourceBinding bind: 0 uniformBuffer: stateUniformBuffer.
	resourceBinding bind: 2 texture: (heightMapTexture ifNil: [resourceCache blackTexture] ) startMiplevel: 0 miplevels: -1 lodclamp: 100000.0.
	resourceBinding bind: 3 texture: (splattingTexture ifNil: [resourceCache blackTexture]) startMiplevel: 0 miplevels: -1 lodclamp: 100000.0.
	
	0 to: 4 do: [ :i |
		resourceBinding bind: 4 + i texture: (self validAlbedoTexture: i + 1) startMiplevel: 0 miplevels: -1 lodclamp: 100000.0.
	].

	0 to: 4 do: [ :i |
		resourceBinding bind: 9 + i texture: (self validNormalTexture: i + 1) startMiplevel: 0 miplevels: -1 lodclamp: 100000.0.
	].
	
]

{ #category : #'state binding' }
WDCTerrainMaterial >> fetchShaders [

	vertexShader ifNil: [ 
		vertexShader := engine loadVertexShader: 'shaders/surface/terrainVertex.dastrel'.
	].

	fragmentShader ifNil: [ 
		fragmentShader := engine loadFragmentShader: 'shaders/surface/terrainForward.dastrel'.
	]

]

{ #category : #accessing }
WDCTerrainMaterial >> heightMapOffset: aVector2 [
	materialState heightMapOffset: aVector2
]

{ #category : #accessing }
WDCTerrainMaterial >> heightMapScale: aVector2 [
	materialState heightMapScale: aVector2
]

{ #category : #accessing }
WDCTerrainMaterial >> heightMapTexture [
	^ heightMapTexture
]

{ #category : #accessing }
WDCTerrainMaterial >> heightMapTexture: anObject [
	heightMapTexture := anObject
]

{ #category : #accessing }
WDCTerrainMaterial >> heightOffset: aFloat [
	materialState heightOffset: aFloat
]

{ #category : #accessing }
WDCTerrainMaterial >> heightScale: aFloat [
	materialState heightScale: aFloat
]

{ #category : #initialization }
WDCTerrainMaterial >> initialize [
	materialState := WDCTerrainMaterialState new
		heightMapScale: (WMVector2F x: 1.0 y: 1.0);
		heightMapOffset: WMVector2F zero;
		heightScale: 1.0;

		albedo: Color white asWMVector4F;
		fresnel: (WMVector3F x: 0.03 y: 0.03 z: 0.03);
		smoothness: 0.45;
		yourself.
	albedoTextures := { nil . nil . nil . nil . nil }.
	normalTextures := { nil . nil . nil . nil . nil }.
	self invalidateCache.
]

{ #category : #initialization }
WDCTerrainMaterial >> invalidateCache [
	resourceBindingsAreUpdated := false.
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

{ #category : #accessing }
WDCTerrainMaterial >> splattingTexture [
	^ splattingTexture
]

{ #category : #accessing }
WDCTerrainMaterial >> splattingTexture: anObject [
	splattingTexture := anObject
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
WDCTerrainMaterial >> validNormalTexture: textureIndex [
	^ (normalTextures at: textureIndex) ifNil: [ engine resourceCache defaultNormalTexture ]
]

{ #category : #'state binding' }
WDCTerrainMaterial >> validateCache [
	(vertexShader isNil or: [fragmentShader isNil]) ifTrue: [ self fetchShaders ].
	resourceBindingsAreUpdated ifFalse: [ self bindResources ].
	resourceBindingsAreUpdated := true.
]
