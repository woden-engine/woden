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
		'fragmentShader',
		'depthNormalFragmentShader',
		'shaderLibrary',
		'forwardFragmentShader'
	],
	#category : #'WodenEngine-Core-Material'
}

{ #category : #rendering }
WDCGenericSurfaceMaterial >> activateDepthNormalOn: stateTracker [
	self validateCache.
	stateTracker
		vertexShader: self vertexShader;
		fragmentShader: self depthNormalFragmentShader.
		
	normalTexture ifNotNil: [ 
		resourceBinding ifNotNil: [ 
			stateTracker useShaderResources: resourceBinding.
		].
	].
	^ true
]

{ #category : #rendering }
WDCGenericSurfaceMaterial >> activateDepthOnlyOn: stateTracker [
	self validateCache.
	stateTracker
		vertexShader: self vertexShader;
		fragmentShader: nil.
	^ true
]

{ #category : #rendering }
WDCGenericSurfaceMaterial >> activateForwardOn: stateTracker [
	self validateCache.
	
	stateTracker
		vertexShader: self vertexShader;
		fragmentShader: self forwardFragmentShader.
	
	stateTracker submode == #solid ifTrue: [
		stateTracker fragmentShader: self solidFragmentShader
	].
	stateTracker submode == #wire ifTrue: [
		stateTracker
			materialPolygonMode: AGPU_POLYGON_MODE_LINE;
			materialCullMode: AGPU_CULL_MODE_NONE;
			fragmentShader: self wireFragmentShader
	].

	resourceBinding ifNotNil: [ 
		stateTracker useShaderResources: resourceBinding.
	].
	
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
		signature := WDCSceneRenderingShaderSignature for: engine.
		resourceBinding := signature newMaterialState.
	].

	stateUniformBuffer ifNil: [
		self flag: 'Use a memory pool here.'.
		stateUniformBuffer := engine createStreamingUniformBuffer: (WTGenericSurfaceMaterialState structureSize alignedTo: 256).
		self uploadMaterialStateData.
	].

	resourceBinding bind: 0 uniformBuffer: stateUniformBuffer.
	albedoTexture ifNotNil: [ resourceBinding bind: 2 texture: albedoTexture].
	normalTexture ifNotNil: [ resourceBinding bind: 3 texture: normalTexture].
	fresnelTexture ifNotNil: [ resourceBinding bind: 4 texture: fresnelTexture].
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

{ #category : #shaders }
WDCGenericSurfaceMaterial >> depthNormalFragmentShader [
	^ depthNormalFragmentShader ifNil: [
		depthNormalFragmentShader := self shaderLibrary getFragmentStage: #depthNormal_fragment
	]

]

{ #category : #shaders }
WDCGenericSurfaceMaterial >> forwardFragmentShader [
	^ forwardFragmentShader ifNil: [ 
		forwardFragmentShader := 
		albedoTexture ifNotNil: [ 
			normalTexture ifNotNil: [
				fresnelTexture ifNotNil: [
					self shaderLibrary getFragmentStage: #forward_albedoNormalFresnel
				] ifNil: [
					self shaderLibrary getFragmentStage: #forward_albedoNormal
				]		
			] ifNil: [
				fresnelTexture ifNotNil: [ 
					self shaderLibrary getFragmentStage: #forward_albedoFresnel
			] ifNil: [
					self shaderLibrary getFragmentStage: #forward_albedo
				]
			]	
		] ifNil: [
			self shaderLibrary getFragmentStage: #forward_color
		].
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
	vertexShader := nil.
	forwardFragmentShader := nil.
	depthNormalFragmentShader := nil.
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

{ #category : #shaders }
WDCGenericSurfaceMaterial >> shaderLibrary [
	^ shaderLibrary ifNil: [ shaderLibrary := engine loadShaderLibrary: 'shaders/material/generic.dastrel' ].

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

{ #category : #shaders }
WDCGenericSurfaceMaterial >> solidFragmentShader [
	^ self forwardFragmentShader
]

{ #category : #accessing }
WDCGenericSurfaceMaterial >> stateUniformBuffer [
	^ stateUniformBuffer
]

{ #category : #accessing }
WDCGenericSurfaceMaterial >> stateUniformBuffer: anObject [
	stateUniformBuffer := anObject
]

{ #category : #preview }
WDCGenericSurfaceMaterial >> thumbnail [
	albedoTexture ifNotNil: [ ^ WDCResourceThumbnail type: self thumbnailType value: albedoTexture thumbnail ].
	^ WDCResourceThumbnail type: self thumbnailType value: self albedoColor asColor
]

{ #category : #preview }
WDCGenericSurfaceMaterial >> thumbnailType [
	isSkinned ifTrue: [ ^ #skinned ].
	^ #generic
]

{ #category : #'state binding' }
WDCGenericSurfaceMaterial >> uploadMaterialStateData [
	stateUniformBuffer ifNotNil: [ 
		materialState storeBytesIn: stateUniformBuffer validPointer getHandle.
	]
	
]

{ #category : #'state binding' }
WDCGenericSurfaceMaterial >> validateCache [
	resourceBindingsAreUpdated ifFalse: [ self bindResources ].
	resourceBindingsAreUpdated := true.
]

{ #category : #shaders }
WDCGenericSurfaceMaterial >> vertexShader [
	^ vertexShader ifNil: [ 
		vertexShader := isSkinned
			ifTrue: [ self shaderLibrary getVertexStage: #skinned_vertex ]
			ifFalse: [ self shaderLibrary getVertexStage: #normal_vertex ]
	].

]

{ #category : #shaders }
WDCGenericSurfaceMaterial >> wireFragmentShader [
	^ self forwardFragmentShader
]
