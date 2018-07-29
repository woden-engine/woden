Class {
	#name : #WDCGenericSurfaceMaterial,
	#superclass : #WDCMaterial,
	#instVars : [
		'albedoTexture',
		'normalTexture',
		'fresnelTexture',
		'smoothnessTexture',
		'resourceBindingsAreUpdated',
		'resourceBinding',
		'materialState',
		'stateUniformBuffer',
		'isSkinned',
		'vertexShader',
		'fragmentShader'
	],
	#category : 'WodenEngine-Core-Material'
}

{ #category : #rendering }
WDCGenericSurfaceMaterial >> activateForwardOn: stateTracker [
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
WDCGenericSurfaceMaterial >> activateShadowOn: stateTracker [
	self validateCache.
	stateTracker
		vertexShader: vertexShader;
		fragmentShader: nil.
	^ true
]

{ #category : #accessing }
WDCGenericSurfaceMaterial >> albedoColor [
	^ materialState albedo
]

{ #category : #accessing }
WDCGenericSurfaceMaterial >> albedoColor: aColor [
	materialState albedo: aColor asWMVector4F.
	self uploadMaterialStateData.
]

{ #category : #accessing }
WDCGenericSurfaceMaterial >> albedoTexture [
	^ albedoTexture
]

{ #category : #accessing }
WDCGenericSurfaceMaterial >> albedoTexture: anObject [
	albedoTexture := anObject.
	self invalidateCache.
]

{ #category : #'state binding' }
WDCGenericSurfaceMaterial >> bindResources [
	| signature |
	resourceBinding ifNil: [ 
		signature := WDCForwardRenderingShaderSignature for: engine.
		resourceBinding := signature newMaterialState.
	].

	stateUniformBuffer ifNil: [
		self flag: 'Use a memory pool here.'.
		stateUniformBuffer := engine createStreamingUniformBuffer: (WTGenericSurfaceMaterialState structureSize alignedTo: 256).
		self uploadMaterialStateData.
	].

	resourceBinding bind: 0 uniformBuffer: stateUniformBuffer.
	albedoTexture ifNotNil: [ resourceBinding bind: 2 texture: albedoTexture startMiplevel: 0 miplevels: -1 lodclamp: 100000.0 ].
	normalTexture ifNotNil: [ resourceBinding bind: 3 texture: normalTexture startMiplevel: 0 miplevels: -1 lodclamp: 100000.0 ].
	fresnelTexture ifNotNil: [ resourceBinding bind: 4 texture: fresnelTexture startMiplevel: 0 miplevels: -1 lodclamp: 100000.0 ].
]

{ #category : #'as yet unclassified' }
WDCGenericSurfaceMaterial >> concretizeMaterial [
	| resourceCache |
	super concretizeMaterial.
	resourceCache := engine resourceCache.
	albedoTexture := engine resourceCache concretizeTexture: albedoTexture.
	normalTexture := engine resourceCache concretizeTexture: normalTexture.
	fresnelTexture := engine resourceCache concretizeTexture: fresnelTexture.
	smoothnessTexture := engine resourceCache concretizeTexture: smoothnessTexture.
]

{ #category : #'state binding' }
WDCGenericSurfaceMaterial >> fetchShaders [

	vertexShader ifNil: [ 
		isSkinned ifTrue: [
			vertexShader := engine loadVertexShader: 'shaders/surface/skinnedGenericVertex.dastrel'.
		] ifFalse: [ 
			vertexShader := engine loadVertexShader: 'shaders/surface/genericVertex.dastrel'.
		]
	].

	albedoTexture ifNotNil: [ 
		normalTexture ifNotNil: [
			fresnelTexture ifNotNil: [
				fragmentShader := engine loadFragmentShader: 'shaders/surface/albedoNormalFresnelTexture.dastrel'.
			] ifNil: [
				fragmentShader := engine loadFragmentShader: 'shaders/surface/albedoNormalTexture.dastrel'.
			]		
		] ifNil: [
			fresnelTexture ifNotNil: [ 
				fragmentShader := engine loadFragmentShader: 'shaders/surface/albedoFresnelTexture.dastrel'.
			] ifNil: [
				fragmentShader := engine loadFragmentShader: 'shaders/surface/albedoTexture.dastrel'.
			]
		]	
	] ifNil: [
		fragmentShader := engine loadFragmentShader: 'shaders/surface/colorForward.dastrel'.
	]

]

{ #category : #accessing }
WDCGenericSurfaceMaterial >> fresnelConstant [
	^ materialState fresnel
]

{ #category : #accessing }
WDCGenericSurfaceMaterial >> fresnelConstant: value [
	materialState fresnel: value.
	self uploadMaterialStateData.
	
]

{ #category : #accessing }
WDCGenericSurfaceMaterial >> fresnelTexture [
	^ fresnelTexture
]

{ #category : #accessing }
WDCGenericSurfaceMaterial >> fresnelTexture: anObject [
	fresnelTexture := anObject.
	self invalidateCache.
]

{ #category : #initialization }
WDCGenericSurfaceMaterial >> initialize [
	materialState := WTGenericSurfaceMaterialState new
		albedo: Color white asWMVector4F;
		fresnel: (WMVector3F x: 0.03 y: 0.03 z: 0.03);
		smoothness: 0.45;
		yourself.
	isSkinned := false.
	self invalidateCache.
]

{ #category : #'state binding' }
WDCGenericSurfaceMaterial >> invalidateCache [
	resourceBindingsAreUpdated := false.
]

{ #category : #accessing }
WDCGenericSurfaceMaterial >> isSkinned [
	^ isSkinned
]

{ #category : #accessing }
WDCGenericSurfaceMaterial >> isSkinned: anObject [
	isSkinned := anObject.
	vertexShader := nil.
]

{ #category : #accessing }
WDCGenericSurfaceMaterial >> normalTexture [
	^ normalTexture
]

{ #category : #accessing }
WDCGenericSurfaceMaterial >> normalTexture: anObject [
	normalTexture := anObject.
	self invalidateCache.

]

{ #category : #parsing }
WDCGenericSurfaceMaterial >> parse: materialFileReference data: data [
	materialState
		albedo: (self parse: data at: materialFileReference srgbColor: 'albedo-color' ifAbsent: [ Color white ]);
		fresnel: (self parse: data at: materialFileReference vector3: 'fresnel-constant' ifAbsent: [ WMVector3F x: 0.03 y: 0.03 z: 0.03 ]);
		smoothness: (data at: 'smoothness' ifAbsent: [ materialState smoothness ]).
	albedoTexture := self parse: data at: materialFileReference optionalSRGBTexture: 'albedo-texture'.
	normalTexture := self parse: data at: materialFileReference optionalTexture: 'normal-texture'.
	fresnelTexture := self parse: data at: materialFileReference optionalSRGBTexture: 'fresnel-texture'.
	isSkinned := data at: 'skinned' ifAbsent: [ false ].
	self invalidateCache.
]

{ #category : #accessing }
WDCGenericSurfaceMaterial >> resourceBinding [
	^ resourceBinding
]

{ #category : #accessing }
WDCGenericSurfaceMaterial >> resourceBinding: anObject [
	resourceBinding := anObject
]

{ #category : #accessing }
WDCGenericSurfaceMaterial >> smoothness [
	^ materialState smoothness
	
]

{ #category : #accessing }
WDCGenericSurfaceMaterial >> smoothness: aFloat [
	materialState smoothness: aFloat.
	self uploadMaterialStateData.
]

{ #category : #accessing }
WDCGenericSurfaceMaterial >> smoothnessTexture [
	^ smoothnessTexture
]

{ #category : #accessing }
WDCGenericSurfaceMaterial >> smoothnessTexture: anObject [
	smoothnessTexture := anObject
]

{ #category : #accessing }
WDCGenericSurfaceMaterial >> stateUniformBuffer [
	^ stateUniformBuffer
]

{ #category : #accessing }
WDCGenericSurfaceMaterial >> stateUniformBuffer: anObject [
	stateUniformBuffer := anObject
]

{ #category : #'state binding' }
WDCGenericSurfaceMaterial >> uploadMaterialStateData [
	stateUniformBuffer ifNotNil: [ 
		materialState storeBytesIn: stateUniformBuffer validPointer getHandle.
	]
	
]

{ #category : #'state binding' }
WDCGenericSurfaceMaterial >> validateCache [
	(vertexShader isNil or: [fragmentShader isNil]) ifTrue: [ self fetchShaders ].
	resourceBindingsAreUpdated ifFalse: [ self bindResources ].
	resourceBindingsAreUpdated := true.
]
