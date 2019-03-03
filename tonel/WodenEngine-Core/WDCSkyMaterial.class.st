Class {
	#name : #WDCSkyMaterial,
	#superclass : #WDCMaterial,
	#instVars : [
		'skyTexture',
		'resourceBindingsAreUpdated',
		'vertexShader',
		'fragmentShader',
		'resourceBinding'
	],
	#category : 'WodenEngine-Core-Material'
}

{ #category : #'state binding' }
WDCSkyMaterial >> activateForwardOn: stateTracker [
	self validateCache.
	resourceBinding ifNotNil: [ 
		stateTracker useShaderResources: resourceBinding.
	].
	
	stateTracker
		vertexShader: vertexShader;
		fragmentShader: fragmentShader;
		materialDepthWriteMask: false.
	^ true
]

{ #category : #'state binding' }
WDCSkyMaterial >> bindResources [
	| signature |
	resourceBinding ifNil: [ 
		signature := WDCForwardRenderingShaderSignature for: engine.
		resourceBinding := signature newMaterialState.
	].
	skyTexture ifNotNil: [ resourceBinding bind: 2 texture: skyTexture ].
]

{ #category : #'state binding' }
WDCSkyMaterial >> fetchShaders [
	vertexShader ifNil: [
		vertexShader := engine loadVertexShader: 'shaders/surface/skyVertex.dastrel'.
	].

	fragmentShader ifNil: [
		fragmentShader := engine loadFragmentShader: 'shaders/surface/skyFragment.dastrel'.
	].
]

{ #category : #initialization }
WDCSkyMaterial >> initialize [
	self invalidateCache.
]

{ #category : #'state binding' }
WDCSkyMaterial >> invalidateCache [
	resourceBindingsAreUpdated := false.
]

{ #category : #parsing }
WDCSkyMaterial >> parse: materialFileReference data: data [
	skyTexture := self parse: data at: materialFileReference optionalSRGBTexture: 'texture'.
	self invalidateCache.
]

{ #category : #accessing }
WDCSkyMaterial >> skyTexture [
	^ skyTexture
]

{ #category : #accessing }
WDCSkyMaterial >> skyTexture: anObject [
	skyTexture := anObject
]

{ #category : #preview }
WDCSkyMaterial >> thumbnail [
	skyTexture ifNotNil: [ ^ WDCResourceThumbnail type: #sky value: skyTexture thumbnail ].
	^ WDCResourceThumbnail type: #sky value: Color blue
]

{ #category : #'state binding' }
WDCSkyMaterial >> validateCache [
	(vertexShader isNil or: [ fragmentShader isNil ]) ifTrue: [ self fetchShaders ].
	resourceBindingsAreUpdated ifFalse: [ self bindResources ].
	resourceBindingsAreUpdated := true.
]
