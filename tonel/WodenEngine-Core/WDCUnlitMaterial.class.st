Class {
	#name : #WDCUnlitMaterial,
	#superclass : #WDCMaterial,
	#instVars : [
		'useDepth',
		'writeDepth',
		'stipple',
		'thumbnailType',
		'shaderLibrary',
		'colorTexture',
		'resourceBindingsAreUpdated',
		'resourceBinding',
		'hasPremultipliedAlpha'
	],
	#category : #'WodenEngine-Core-Material'
}

{ #category : #rendering }
WDCUnlitMaterial >> activateDepthNormalOn: stateTracker [
	stateTracker objectDepthWriteMask == false ifTrue: [ ^ false ].
	
	stateTracker
		vertexShader: self vertexShader;
		fragmentShader: engine resourceCache alwaysFrontDepthNormalFragmentShader.
	^ true
]

{ #category : #rendering }
WDCUnlitMaterial >> activateDepthOnlyOn: stateTracker [
	stateTracker objectDepthWriteMask == false ifTrue: [ ^ false ].
	
	stateTracker
		vertexShader: self vertexShader;
		fragmentShader: nil.
	^ true
]

{ #category : #rendering }
WDCUnlitMaterial >> activateForwardOn: stateTracker [
	self validateCache.
	stateTracker
		vertexShader: self vertexShader;
		fragmentShader: self fragmentShader;
		useShaderResources: resourceBinding;
		materialBlendingMode: (hasPremultipliedAlpha
			ifTrue: [ WDCBlendingMode premultipliedAlphaOver ]
			ifFalse:  [WDCBlendingMode alphaOver]).
		
	useDepth ifFalse: [ 
		stateTracker
			materialDepthFunction: AGPU_ALWAYS;
			materialDepthWriteMask: false
	].

	^ true
]

{ #category : #rendering }
WDCUnlitMaterial >> bindResources [
	| signature |
	resourceBinding ifNil: [ 
		signature := WDCSceneRenderingShaderSignature for: engine.
		resourceBinding := signature newMaterialState.
	].
	colorTexture ifNotNil: [ resourceBinding bind: 2 texture: colorTexture].

]

{ #category : #'as yet unclassified' }
WDCUnlitMaterial >> colorTexture [
	^ colorTexture
]

{ #category : #'as yet unclassified' }
WDCUnlitMaterial >> colorTexture: aTexture [
	colorTexture ~~ aTexture ifTrue: [ 
		colorTexture := aTexture.
		self invalidateCache.
	].

]

{ #category : #accessing }
WDCUnlitMaterial >> fragmentShader [
	^ stipple
		ifTrue: [ self shaderLibrary getFragmentStage: #stipple ]
		ifFalse: [ colorTexture
				ifNotNil: [self shaderLibrary getFragmentStage: #flatTextured]
				ifNil: [self shaderLibrary getFragmentStage: #flat] ]
]

{ #category : #accessing }
WDCUnlitMaterial >> hasPremultipliedAlpha [

	^ hasPremultipliedAlpha
]

{ #category : #accessing }
WDCUnlitMaterial >> hasPremultipliedAlpha: anObject [

	hasPremultipliedAlpha := anObject
]

{ #category : #testing }
WDCUnlitMaterial >> hasTexture [
	^ colorTexture isNotNil
]

{ #category : #initialization }
WDCUnlitMaterial >> initialize [
	super initialize.
	stipple := false.
	useDepth := true.
	writeDepth := true.
	resourceBindingsAreUpdated := false.
	hasPremultipliedAlpha := false.
]

{ #category : #'as yet unclassified' }
WDCUnlitMaterial >> invalidateCache [
	resourceBindingsAreUpdated := false.
]

{ #category : #parsing }
WDCUnlitMaterial >> parseInFolder: parentFolderFileReference data: aDictionary [
	useDepth := aDictionary at: #useDepth ifAbsent: [ true ].
	writeDepth := aDictionary at: #writeDepth ifAbsent: [ true ].
	stipple := aDictionary at: #stipple ifAbsent: [ false ].
	thumbnailType := (aDictionary at: #thumbnailType ifAbsent: [ #color ]) asSymbol.
]

{ #category : #enumerating }
WDCUnlitMaterial >> precacheResources [
	self shaderLibrary
]

{ #category : #accessing }
WDCUnlitMaterial >> shaderLibrary [
	^ shaderLibrary ifNil: [ shaderLibrary := engine loadShaderLibrary: 'shaders/material/flat.dastrel' ].

]

{ #category : #accessing }
WDCUnlitMaterial >> stipple [
	^ stipple
]

{ #category : #accessing }
WDCUnlitMaterial >> stipple: anObject [
	stipple := anObject
]

{ #category : #preview }
WDCUnlitMaterial >> thumbnail [
	^ WDCResourceThumbnail type: thumbnailType value: Color white
]

{ #category : #accessing }
WDCUnlitMaterial >> thumbnailType [
	^ thumbnailType
]

{ #category : #accessing }
WDCUnlitMaterial >> thumbnailType: anObject [
	thumbnailType := anObject
]

{ #category : #accessing }
WDCUnlitMaterial >> useDepth [
	^ useDepth
]

{ #category : #accessing }
WDCUnlitMaterial >> useDepth: anObject [
	useDepth := anObject
]

{ #category : #rendering }
WDCUnlitMaterial >> validateCache [
	resourceBindingsAreUpdated ifFalse: [ self bindResources ].
	resourceBindingsAreUpdated := true.
]

{ #category : #accessing }
WDCUnlitMaterial >> vertexShader [
	^ self shaderLibrary getVertexStage: #vertex
]

{ #category : #accessing }
WDCUnlitMaterial >> writeDepth [
	^ writeDepth
]

{ #category : #accessing }
WDCUnlitMaterial >> writeDepth: anObject [
	writeDepth := anObject
]
