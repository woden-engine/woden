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
		'shaderLibrary',
		'doubleSided',
		'translucent'
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
	translucent ifTrue: [ ^ false ].
	stateTracker submode isWireFrame ifTrue: [ ^ false ].

	self validateCache.
	stateTracker
		vertexShader: (self depthNormalVertexShaderFor: stateTracker);
		fragmentShader: (self depthNormalFragmentShaderFor: stateTracker).
		
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
	translucent ifTrue: [ ^ false ].
	stateTracker submode isWireFrame ifTrue: [ ^ false ].

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
		fragmentShader: (self forwardFragmentShaderFor: stateTracker).
	
	stateTracker submode isWireFrame ifTrue: [
		stateTracker
			materialPolygonMode: AGPU_POLYGON_MODE_LINE;
			materialCullMode: AGPU_CULL_MODE_NONE
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
	materialState albedo: aColor asFloat32x4.
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

{ #category : #accessing }
WDCAbstractGenericSurfaceMaterial >> baseColor [
	^ self albedoColor
]

{ #category : #accessing }
WDCAbstractGenericSurfaceMaterial >> baseColor: aColor [
	self albedoColor: aColor
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
		stateUniformBuffer := engine createStreamingUniformBuffer: (self materialStateClass instanceSize alignedTo: 256).
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
WDCAbstractGenericSurfaceMaterial >> depthNormalFragmentShaderFor: stateTracker [
	^ (albedoTexture isNil or: [stateTracker submode hasNoTextures]) ifTrue: [ 
		self shaderLibrary getFragmentStage: #depthNormal_fragment
	] ifFalse: [ 
		self shaderLibrary getFragmentStage: #depthNormalMask_fragment
	].

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
	materialState emission: (Float32x4 xyz: aColor asFloat32x3 w: 0.0).
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

{ #category : #shaders }
WDCAbstractGenericSurfaceMaterial >> forwardFragmentShaderFor: stateTracker [
	^ self subclassResponsibility
]

{ #category : #initialization }
WDCAbstractGenericSurfaceMaterial >> initialize [
	materialState := self materialStateClass new
		albedo: Color white asFloat32x4;
		yourself.
	doubleSided := false.
	translucent := false.
	self invalidateCache.
]

{ #category : #'state binding' }
WDCAbstractGenericSurfaceMaterial >> invalidateCache [
	resourceBindingsAreUpdated := false.
]

{ #category : #testing }
WDCAbstractGenericSurfaceMaterial >> isTranslucentMaterial [
	^ translucent
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

{ #category : #accessing }
WDCAbstractGenericSurfaceMaterial >> occlusionFactor: occlusionFactor [
]

{ #category : #parsing }
WDCAbstractGenericSurfaceMaterial >> parseInFolder: parentFolderFileReference data: data [
	materialState albedo: (self parse: data at: parentFolderFileReference srgbColor: #baseColorFactor ifAbsent: [ Color white ]).
	albedoTexture := self parse: data at: parentFolderFileReference optionalSRGBTexture: #baseColorTexture.
	normalTexture := self parse: data at: parentFolderFileReference optionalTexture: #normalTexture.
	materialState
		alphaCutoff: (data at: #alphaCutoff ifAbsent: [ materialState alphaCutoff ]).
]

{ #category : #enumerating }
WDCAbstractGenericSurfaceMaterial >> precacheResources [
	self shaderLibrary
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

{ #category : #'as yet unclassified' }
WDCAbstractGenericSurfaceMaterial >> setupRenderableTranslucency: renderable [
	translucent ifTrue: [
		renderable
			makeTranslucentSorted;
			blendingMode: WDCBlendingMode alphaOver
	]
]

{ #category : #rendering }
WDCAbstractGenericSurfaceMaterial >> shaderLibrary [
	self subclassResponsibility
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

{ #category : #accessing }
WDCAbstractGenericSurfaceMaterial >> translucent [
	^ translucent
]

{ #category : #accessing }
WDCAbstractGenericSurfaceMaterial >> translucent: anObject [
	translucent := anObject
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
	^ self shaderLibrary getVertexStage: (VertexShaderVariantTable at: { stateTracker hasSkinning . stateTracker hasVertexColors . stateTracker hasVertexTangents })
]
