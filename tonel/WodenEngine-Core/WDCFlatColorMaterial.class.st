Class {
	#name : #WDCFlatColorMaterial,
	#superclass : #WDCMaterial,
	#instVars : [
		'useDepth',
		'writeDepth',
		'stipple',
		'thumbnailType',
		'vertexShader',
		'fragmentShader'
	],
	#category : 'WodenEngine-Core-Material'
}

{ #category : #rendering }
WDCFlatColorMaterial >> activateForwardOn: stateTracker [
	self validateCache.
	stateTracker
		vertexShader: vertexShader;
		fragmentShader: fragmentShader.
	^ true
]

{ #category : #rendering }
WDCFlatColorMaterial >> activateShadowOn: stateTracker [
	self validateCache.
	stateTracker
		vertexShader: vertexShader;
		fragmentShader: nil.
	^ true
]

{ #category : #parsing }
WDCFlatColorMaterial >> parse: materialFileReference data: aDictionary [
	useDepth := aDictionary at: 'use-depth' ifAbsent: [ true ].
	writeDepth := aDictionary at: 'write-depth' ifAbsent: [ true ].
	stipple := aDictionary at: 'stipple' ifAbsent: [ false ].
	thumbnailType := (aDictionary at: 'thumbnail-type' ifAbsent: [ #color ]) asSymbol.
]

{ #category : #accessing }
WDCFlatColorMaterial >> stipple [
	^ stipple
]

{ #category : #accessing }
WDCFlatColorMaterial >> stipple: anObject [
	stipple := anObject
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

{ #category : #'state binding' }
WDCFlatColorMaterial >> validateCache [
	vertexShader ifNil: [
		vertexShader := engine loadVertexShader: 'shaders/surface/genericVertex.dastrel'.
	].

	fragmentShader ifNil: [
		stipple ifFalse: [
			fragmentShader := engine loadFragmentShader: 'shaders/surface/flatColorForward.dastrel'.
		] ifTrue: [ 
			fragmentShader := engine loadFragmentShader: 'shaders/surface/flatColorStippleForward.dastrel'.
		].
	]
]

{ #category : #accessing }
WDCFlatColorMaterial >> writeDepth [
	^ writeDepth
]

{ #category : #accessing }
WDCFlatColorMaterial >> writeDepth: anObject [
	writeDepth := anObject
]
