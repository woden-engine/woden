Class {
	#name : #WDCWaterMaterial,
	#superclass : #WDCMaterial,
	#instVars : [
		'resourceBindingsAreUpdated',
		'fragmentShader',
		'resourceBinding',
		'stateUniformBuffer',
		'materialState',
		'normalTexture',
		'useClipMap',
		'albedoTexture',
		'shaderLibrary'
	],
	#category : #'WodenEngine-Core-Material'
}

{ #category : #rendering }
WDCWaterMaterial >> activateForwardOn: stateTracker [
	self validateCache.
	stateTracker hasWaterDeformationState ifFalse: [ ^ false ].
	
	resourceBinding ifNotNil: [ stateTracker useShaderResources: resourceBinding ].
	stateTracker
		vertexShader: (self vertexShaderFor: stateTracker);
		fragmentShader: self fragmentShader;
		materialBlendingMode: WDCBlendingMode premultipliedAlphaOver;
		materialCullMode: AGPU_CULL_MODE_NONE.
	stateTracker submode == #solid ifTrue: [
		stateTracker fragmentShader: self solidFragmentShader
	].
	stateTracker submode == #wire ifTrue: [
		stateTracker
			materialPolygonMode: AGPU_POLYGON_MODE_LINE;
			materialCullMode: AGPU_CULL_MODE_NONE;
			fragmentShader: self wireFragmentShader
	].
	^ true
]

{ #category : #accessing }
WDCWaterMaterial >> albedoColor [
	^ materialState albedo
]

{ #category : #'state binding' }
WDCWaterMaterial >> bindResources [
	| signature resourceCache |
	resourceBinding ifNil: [
		signature := WDCSceneRenderingShaderSignature for: engine.
		resourceBinding := signature newMaterialState.
	].

	stateUniformBuffer ifNil: [
		stateUniformBuffer := engine createStreamingUniformBuffer: (materialState class structureSize alignedTo: 256).
		self uploadMaterialStateData.
	].

	resourceCache := engine resourceCache.
	resourceBinding
		bind: 0 uniformBuffer: stateUniformBuffer;
		bind: 2 texture: (albedoTexture ifNil: [resourceCache whiteTexture]);
		bind: 3 texture: (normalTexture ifNil: [resourceCache defaultNormalTexture]).
]

{ #category : #'terrain mesh building' }
WDCWaterMaterial >> createTerrainMeshForSceneNode: sceneNode boundingBox: boundingBox [
	self flag: 'TODO: Support parameterizing this.'.
	^ (WDCTerrainMeshBuilder for: self engine)
		material: self;
		createGridWithSize: (WMVector2F x: boundingBox width y: boundingBox depth)
			subdivisions: 64;
		mesh
]

{ #category : #shaders }
WDCWaterMaterial >> fragmentShader [
	^ fragmentShader ifNil: [
		fragmentShader := self shaderLibrary getFragmentStage: #forward_color
	]
]

{ #category : #initialization }
WDCWaterMaterial >> initialize [
	materialState := WDCWaterMaterialState new
		albedo: Color white asWMVector4F;
		fresnel: (WMVector3F x: 0.04 y: 0.04 z: 0.04);
		smoothness: 0.45;
		propagationSpeed: 2.0;
		textureScale: (WMVector2F x: 1.0 y: 1.0);
		yourself.
		
	self invalidateCache.
]

{ #category : #'as yet unclassified' }
WDCWaterMaterial >> invalidateCache [
	resourceBindingsAreUpdated := false.
]

{ #category : #testing }
WDCWaterMaterial >> isTranslucentMaterial [
	^ true
]

{ #category : #accessing }
WDCWaterMaterial >> materialState [
	^ materialState
]

{ #category : #parsing }
WDCWaterMaterial >> parse: materialFileReference data: data [
	materialState
		textureOffset: (self parse: data at: materialFileReference vector2: 'texture-offset' ifAbsent: [ WMVector2F zero ]);
		textureScale: (self parse: data at: materialFileReference vector2: 'texture-scale' ifAbsent: [ WMVector2F x: 1.0 y: 1.0 ]);

		albedo: (self parse: data at: materialFileReference srgbColor: 'albedo' ifAbsent: [ Color white ]);
		fresnel: (self parse: data at: materialFileReference vector3: 'fresnel' ifAbsent: [ WMVector3F x: 0.04 y: 0.04 z: 0.04 ]);
		smoothness: (1.0 - (data at: 'roughness' ifAbsent: [0.0])).
	albedoTexture := self parse: data at: materialFileReference optionalSRGBTexture: 'albedo-texture'.
	normalTexture := self parse: data at: materialFileReference optionalTexture: 'normal-texture'.
	self invalidateCache.
]

{ #category : #enumerating }
WDCWaterMaterial >> precacheResources [
	self shaderLibrary
]

{ #category : #shaders }
WDCWaterMaterial >> shaderLibrary [
	^ shaderLibrary ifNil: [ shaderLibrary := engine loadShaderLibrary: 'shaders/material/water.dastrel' ].

]

{ #category : #shaders }
WDCWaterMaterial >> solidFragmentShader [
	^ self fragmentShader
]

{ #category : #preview }
WDCWaterMaterial >> thumbnail [
	^ WDCResourceThumbnail type: #water value: self albedoColor asColor
]

{ #category : #'state binding' }
WDCWaterMaterial >> uploadMaterialStateData [
	stateUniformBuffer ifNotNil: [ 
		materialState storeBytesIn: stateUniformBuffer validPointer getHandle.
	]
	
]

{ #category : #'state binding' }
WDCWaterMaterial >> validateCache [
	resourceBindingsAreUpdated ifFalse: [ self bindResources ].
	resourceBindingsAreUpdated := true.
]

{ #category : #shaders }
WDCWaterMaterial >> vertexShaderFor: stateTracker [
	^ stateTracker hasVertexNormals
		ifTrue: [ self shaderLibrary getVertexStage: #genericVertex ]
		ifFalse: [ self shaderLibrary getVertexStage: #vertex ]
]

{ #category : #shaders }
WDCWaterMaterial >> wireFragmentShader [
	^ self fragmentShader
]
