Class {
	#name : #WDCFlatColorMaterial,
	#superclass : #WDCMaterial,
	#instVars : [
		'useDepth',
		'writeDepth',
		'stipple',
		'thumbnailType',
		'vertexShader',
		'fragmentShader',
		'shaderLibrary'
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
	stateTracker
		vertexShader: self vertexShader;
		fragmentShader: self fragmentShader;
		materialBlendingMode: WDCBlendingMode alphaOver.
		
	useDepth ifFalse: [ 
		stateTracker
			materialDepthFunction: AGPU_ALWAYS;
			materialDepthWriteMask: false
	].

	^ true
]

{ #category : #accessing }
WDCFlatColorMaterial >> fragmentShader [
	^ fragmentShader ifNil: [
		fragmentShader := stipple
			ifTrue: [ self shaderLibrary getFragmentStage: #stipple ]
			ifFalse: [ self shaderLibrary getFragmentStage: #flat ]
	]
]

{ #category : #parsing }
WDCFlatColorMaterial >> parse: materialFileReference data: aDictionary [
	useDepth := aDictionary at: 'use-depth' ifAbsent: [ true ].
	writeDepth := aDictionary at: 'write-depth' ifAbsent: [ true ].
	stipple := aDictionary at: 'stipple' ifAbsent: [ false ].
	thumbnailType := (aDictionary at: 'thumbnail-type' ifAbsent: [ #color ]) asSymbol.
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

{ #category : #accessing }
WDCFlatColorMaterial >> vertexShader [
	^ vertexShader ifNil: [vertexShader := self shaderLibrary getVertexStage: #vertex ]
]

{ #category : #accessing }
WDCFlatColorMaterial >> writeDepth [
	^ writeDepth
]

{ #category : #accessing }
WDCFlatColorMaterial >> writeDepth: anObject [
	writeDepth := anObject
]
