Class {
	#name : #WDCFlatColorMaterial,
	#superclass : #WDCMaterial,
	#instVars : [
		'useDepth',
		'writeDepth',
		'stipple',
		'thumbnailType',
		'shaderLibrary',
		'colorTexture',
		'resourceBindingsAreUpdated',
		'resourceBinding'
	],
	#category : #'WodenEngine-Core-Material'
}

{ #category : #rendering }
WDCFlatColorMaterial >> activateDepthNormalOn: stateTracker [
	stateTracker objectDepthWriteMask == false ifTrue: [ ^ false ].
	
	stateTracker
		vertexShader: self vertexShader;
		fragmentShader: engine resourceCache alwaysFrontDepthNormalFragmentShader.
	^ true
]

{ #category : #rendering }
WDCFlatColorMaterial >> activateDepthOnlyOn: stateTracker [
	stateTracker objectDepthWriteMask == false ifTrue: [ ^ false ].
	
	stateTracker
		vertexShader: self vertexShader;
		fragmentShader: nil.
	^ true
]

{ #category : #rendering }
WDCFlatColorMaterial >> activateForwardOn: stateTracker [
	self validateCache.
	stateTracker
		vertexShader: self vertexShader;
		fragmentShader: self fragmentShader;
		useShaderResources: resourceBinding;
		materialBlendingMode: WDCBlendingMode alphaOver.
		
	useDepth ifFalse: [ 
		stateTracker
			materialDepthFunction: AGPU_ALWAYS;
			materialDepthWriteMask: false
	].

	^ true
]

{ #category : #rendering }
WDCFlatColorMaterial >> bindResources [
	| signature |
	resourceBinding ifNil: [ 
		signature := WDCSceneRenderingShaderSignature for: engine.
		resourceBinding := signature newMaterialState.
	].
	colorTexture ifNotNil: [ resourceBinding bind: 2 texture: colorTexture].

]

{ #category : #'as yet unclassified' }
WDCFlatColorMaterial >> colorTexture [
	^ colorTexture
]

{ #category : #'as yet unclassified' }
WDCFlatColorMaterial >> colorTexture: aTexture [
	colorTexture ~~ aTexture ifTrue: [ 
		colorTexture := aTexture.
		self invalidateCache.
	].

]

{ #category : #accessing }
WDCFlatColorMaterial >> fragmentShader [
	^ stipple
		ifTrue: [ self shaderLibrary getFragmentStage: #stipple ]
		ifFalse: [ colorTexture
				ifNotNil: [self shaderLibrary getFragmentStage: #flatTextured]
				ifNil: [self shaderLibrary getFragmentStage: #flat] ]
]

{ #category : #initialization }
WDCFlatColorMaterial >> initialize [
	super initialize.
	stipple := false.
	useDepth := true.
	writeDepth := true.
	resourceBindingsAreUpdated := false.
]

{ #category : #'as yet unclassified' }
WDCFlatColorMaterial >> invalidateCache [
	resourceBindingsAreUpdated := false.
]

{ #category : #parsing }
WDCFlatColorMaterial >> parse: materialFileReference data: aDictionary [
	useDepth := aDictionary at: 'use-depth' ifAbsent: [ true ].
	writeDepth := aDictionary at: 'write-depth' ifAbsent: [ true ].
	stipple := aDictionary at: 'stipple' ifAbsent: [ false ].
	thumbnailType := (aDictionary at: 'thumbnail-type' ifAbsent: [ #color ]) asSymbol.
]

{ #category : #enumerating }
WDCFlatColorMaterial >> precacheResources [
	self shaderLibrary
]

{ #category : #accessing }
WDCFlatColorMaterial >> shaderLibrary [
	^ shaderLibrary ifNil: [ shaderLibrary := engine loadShaderLibrary: 'shaders/material/flat.dastrel' ].

]

{ #category : #accessing }
WDCFlatColorMaterial >> stipple [
	^ stipple
]

{ #category : #accessing }
WDCFlatColorMaterial >> stipple: anObject [
	stipple := anObject
]

{ #category : #preview }
WDCFlatColorMaterial >> thumbnail [
	^ WDCResourceThumbnail type: thumbnailType value: Color white
]

{ #category : #accessing }
WDCFlatColorMaterial >> thumbnailType [
	^ thumbnailType
]

{ #category : #accessing }
WDCFlatColorMaterial >> thumbnailType: anObject [
	thumbnailType := anObject
]

{ #category : #accessing }
WDCFlatColorMaterial >> useDepth [
	^ useDepth
]

{ #category : #accessing }
WDCFlatColorMaterial >> useDepth: anObject [
	useDepth := anObject
]

{ #category : #rendering }
WDCFlatColorMaterial >> validateCache [
	resourceBindingsAreUpdated ifFalse: [ self bindResources ].
	resourceBindingsAreUpdated := true.
]

{ #category : #accessing }
WDCFlatColorMaterial >> vertexShader [
	^ self shaderLibrary getVertexStage: #vertex
]

{ #category : #accessing }
WDCFlatColorMaterial >> writeDepth [
	^ writeDepth
]

{ #category : #accessing }
WDCFlatColorMaterial >> writeDepth: anObject [
	writeDepth := anObject
]
