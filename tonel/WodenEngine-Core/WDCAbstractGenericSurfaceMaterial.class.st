Class {
	#name : #WDCAbstractGenericSurfaceMaterial,
	#superclass : #WDCMaterial,
	#instVars : [
		'emissionTexture',
		'albedoTexture',
		'normalTexture',
		'resourceBindingsAreUpdated',
		'resourceBinding',
		'materialState',
		'stateUniformBuffer',
		'depthNormalFragmentShader',
		'forwardFragmentShader',
		'shaderLibrary',
		'doubleSided'
	],
	#classVars : [
		'VertexShaderVariantTable'
	],
	#category : #'WodenEngine-Core-Material'
}

{ #category : #'class initialization' }
WDCAbstractGenericSurfaceMaterial class >> initialize [
	super initialize.
	VertexShaderVariantTable := Dictionary newFromPairs: #(
		"skinned color tangent"
		(true true true) skinnedColorNormal_vertex
		(true true false) skinnedColor_vertex
		(true false true) skinnedNormal_vertex
		(true false false) skinned_vertex

		(false true true) colorNormal_vertex
		(false true false) color_vertex
		(false false true) normal_vertex
		(false false false) flat_vertex
	)
]

{ #category : #rendering }
WDCAbstractGenericSurfaceMaterial >> activateDepthNormalOn: stateTracker [
	stateTracker objectDepthWriteMask == false ifTrue: [ ^ false ].

	self validateCache.
	stateTracker
		vertexShader: (self depthNormalVertexShaderFor: stateTracker);
		fragmentShader: self depthNormalFragmentShader.
		
	resourceBinding ifNotNil: [ 
		stateTracker useShaderResources: resourceBinding.
	].

	doubleSided ifTrue: [ 
		stateTracker materialCullMode: AGPU_CULL_MODE_NONE
	].

	^ true
]

{ #category : #rendering }
WDCAbstractGenericSurfaceMaterial >> activateDepthOnlyOn: stateTracker [
	stateTracker objectDepthWriteMask == false ifTrue: [ ^ false ].

	self validateCache.
	stateTracker
		vertexShader: (self depthVertexShaderFor: stateTracker);
		fragmentShader: nil.
		
	resourceBinding ifNotNil: [ 
		stateTracker useShaderResources: resourceBinding.
	].

	doubleSided ifTrue: [ 
		stateTracker materialCullMode: AGPU_CULL_MODE_NONE
	].

	^ true
]

{ #category : #rendering }
WDCAbstractGenericSurfaceMaterial >> activateForwardOn: stateTracker [
	self validateCache.
	
	stateTracker
		vertexShader: (self vertexShaderFor: stateTracker);
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

	doubleSided ifTrue: [ 
		stateTracker materialCullMode: AGPU_CULL_MODE_NONE
	].

	resourceBinding ifNotNil: [ 
		stateTracker useShaderResources: resourceBinding.
	].
	
	^ true
]

{ #category : #accessing }
WDCAbstractGenericSurfaceMaterial >> albedoColor [
	^ materialState albedo
]

{ #category : #accessing }
WDCAbstractGenericSurfaceMaterial >> albedoColor: aColor [
	materialState albedo: aColor asWMVector4F.
	self uploadMaterialStateData.
]

{ #category : #accessing }
WDCAbstractGenericSurfaceMaterial >> albedoTexture [
	^ albedoTexture
]

{ #category : #accessing }
WDCAbstractGenericSurfaceMaterial >> albedoTexture: anObject [
	albedoTexture := anObject.
	self invalidateCache.
]

{ #category : #accessing }
WDCAbstractGenericSurfaceMaterial >> alphaCutoff [
	^ materialState alphaCutoff
]

{ #category : #accessing }
WDCAbstractGenericSurfaceMaterial >> alphaCutoff: aFloat [
	materialState alphaCutoff: aFloat asFloat.
	self uploadMaterialStateData.
]

{ #category : #'state binding' }
WDCAbstractGenericSurfaceMaterial >> bindResources [
	| signature |
	resourceBinding ifNil: [ 
		signature := WDCSceneRenderingShaderSignature for: engine.
		resourceBinding := signature newMaterialState.
	].

	stateUniformBuffer ifNil: [
		self flag: 'Use a memory pool here.'.
		stateUniformBuffer := engine createStreamingUniformBuffer: (self materialStateClass structureSize alignedTo: 256).
		self uploadMaterialStateData.
	].

	resourceBinding bind: 0 uniformBuffer: stateUniformBuffer.
	albedoTexture ifNotNil: [ resourceBinding bind: 2 texture: albedoTexture].
	normalTexture ifNotNil: [ resourceBinding bind: 3 texture: normalTexture].
	resourceBinding bind: 4 texture: (emissionTexture ifNil: [engine resourceCache whiteTexture]).
]

{ #category : #'as yet unclassified' }
WDCAbstractGenericSurfaceMaterial >> concretizeMaterial [
	| resourceCache |
	super concretizeMaterial.
	resourceCache := engine resourceCache.
	albedoTexture := engine resourceCache concretizeTexture: albedoTexture.
	normalTexture := engine resourceCache concretizeTexture: normalTexture.
	emissionTexture := engine resourceCache concretizeTexture: emissionTexture.
]

{ #category : #shaders }
WDCAbstractGenericSurfaceMaterial >> depthNormalFragmentShader [
	^ depthNormalFragmentShader ifNil: [
		albedoTexture ifNil: [ 
			depthNormalFragmentShader := self shaderLibrary getFragmentStage: #depthNormal_fragment
		] ifNotNil: [ 
			depthNormalFragmentShader := self shaderLibrary getFragmentStage: #depthNormalMask_fragment
		].
	]

]

{ #category : #shaders }
WDCAbstractGenericSurfaceMaterial >> depthNormalVertexShaderFor: stateTracker [
	^ self depthVertexShaderFor: stateTracker
]

{ #category : #shaders }
WDCAbstractGenericSurfaceMaterial >> depthVertexShaderFor: stateTracker [
	^ stateTracker hasSkinning
			ifTrue: [ self shaderLibrary getVertexStage: #depthSkinned_vertex ]
			ifFalse: [ self shaderLibrary getVertexStage: #depth_vertex ]
]

{ #category : #accessing }
WDCAbstractGenericSurfaceMaterial >> doubleSided [
	^ doubleSided
]

{ #category : #accessing }
WDCAbstractGenericSurfaceMaterial >> doubleSided: anObject [
	doubleSided := anObject
]

{ #category : #accessing }
WDCAbstractGenericSurfaceMaterial >> emissionColor [
	^ materialState emission
]

{ #category : #accessing }
WDCAbstractGenericSurfaceMaterial >> emissionColor: aColor [
	materialState emission: aColor asWMVector4F.
	self uploadMaterialStateData.
]

{ #category : #accessing }
WDCAbstractGenericSurfaceMaterial >> emissionTexture [
	^ emissionTexture
]

{ #category : #accessing }
WDCAbstractGenericSurfaceMaterial >> emissionTexture: anObject [
	emissionTexture := anObject
]

{ #category : #rendering }
WDCAbstractGenericSurfaceMaterial >> forwardFragmentShader [
	self subclassResponsibility
]

{ #category : #initialization }
WDCAbstractGenericSurfaceMaterial >> initialize [
	materialState := self materialStateClass new
		albedo: Color white asWMVector4F;
		yourself.
	doubleSided := false.
	self invalidateCache.
]

{ #category : #'state binding' }
WDCAbstractGenericSurfaceMaterial >> invalidateCache [
	resourceBindingsAreUpdated := false.
	forwardFragmentShader := nil.
	depthNormalFragmentShader := nil.
]

{ #category : #'state binding' }
WDCAbstractGenericSurfaceMaterial >> materialStateClass [
	self subclassResponsibility
]

{ #category : #accessing }
WDCAbstractGenericSurfaceMaterial >> normalTexture [
	^ normalTexture
]

{ #category : #accessing }
WDCAbstractGenericSurfaceMaterial >> normalTexture: anObject [
	normalTexture := anObject.
	self invalidateCache.

]

{ #category : #parsing }
WDCAbstractGenericSurfaceMaterial >> parse: materialFileReference data: data [
	materialState albedo: (self parse: data at: materialFileReference srgbColor: 'albedo-color' ifAbsent: [ Color white ]).
	albedoTexture := self parse: data at: materialFileReference optionalSRGBTexture: 'albedo-texture'.
	normalTexture := self parse: data at: materialFileReference optionalTexture: 'normal-texture'.
	materialState
		alphaCutoff: (data at: 'alpha-cutoff' ifAbsent: [ materialState alphaCutoff ]).
]

{ #category : #testing }
WDCAbstractGenericSurfaceMaterial >> requiresTangentSpaceData [
	^ normalTexture isNotNil
]

{ #category : #accessing }
WDCAbstractGenericSurfaceMaterial >> resourceBinding [
	^ resourceBinding
]

{ #category : #accessing }
WDCAbstractGenericSurfaceMaterial >> resourceBinding: anObject [
	resourceBinding := anObject
]

{ #category : #rendering }
WDCAbstractGenericSurfaceMaterial >> shaderLibrary [
	self subclassResponsibility
]

{ #category : #shaders }
WDCAbstractGenericSurfaceMaterial >> solidFragmentShader [
	^ self forwardFragmentShader
]

{ #category : #accessing }
WDCAbstractGenericSurfaceMaterial >> stateUniformBuffer [
	^ stateUniformBuffer
]

{ #category : #accessing }
WDCAbstractGenericSurfaceMaterial >> stateUniformBuffer: anObject [
	stateUniformBuffer := anObject
]

{ #category : #preview }
WDCAbstractGenericSurfaceMaterial >> thumbnail [
	albedoTexture ifNotNil: [ ^ WDCResourceThumbnail type: self thumbnailType value: albedoTexture thumbnail ].
	^ WDCResourceThumbnail type: self thumbnailType value: self albedoColor asColor
]

{ #category : #preview }
WDCAbstractGenericSurfaceMaterial >> thumbnailType [
	^ #generic
]

{ #category : #'state binding' }
WDCAbstractGenericSurfaceMaterial >> uploadMaterialStateData [
	stateUniformBuffer ifNotNil: [ 
		materialState storeBytesIn: stateUniformBuffer validPointer getHandle.
	]
	
]

{ #category : #'state binding' }
WDCAbstractGenericSurfaceMaterial >> validateCache [
	resourceBindingsAreUpdated ifFalse: [ self bindResources ].
	resourceBindingsAreUpdated := true.
]

{ #category : #shaders }
WDCAbstractGenericSurfaceMaterial >> vertexShaderFor: stateTracker [
	^ shaderLibrary getVertexStage: (VertexShaderVariantTable at: { stateTracker hasSkinning . stateTracker hasVertexColors . stateTracker hasVertexTangents })
]

{ #category : #shaders }
WDCAbstractGenericSurfaceMaterial >> wireFragmentShader [
	^ self forwardFragmentShader
]
