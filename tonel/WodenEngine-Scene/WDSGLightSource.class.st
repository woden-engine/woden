"
I represent a light source in the Woden scene graph.
"
Class {
	#name : #WDSGLightSource,
	#superclass : #WDSGNode,
	#instVars : [
		'state',
		'type',
		'castShadows',
		'shadowProjectionMatrix',
		'outerSpotCutoff',
		'innerSpotCutoff',
		'extraShadowDistanceFactor'
	],
	#classVars : [
		'DefaultExtraShadowDistanceFactor',
		'DefaultSpotInnerCutoff',
		'DefaultSpotOuterCutoff'
	],
	#category : #'WodenEngine-Scene-Graph'
}

{ #category : #initialization }
WDSGLightSource class >> initialize [
	super initialize.
	
	DefaultSpotOuterCutoff := 45.
	DefaultSpotInnerCutoff := 40.
	DefaultExtraShadowDistanceFactor := 50.0.
]

{ #category : #accessing }
WDSGLightSource >> castShadows [
	^ castShadows
]

{ #category : #accessing }
WDSGLightSource >> castShadows: anObject [
	castShadows := anObject
]

{ #category : #accessing }
WDSGLightSource >> directional [
	type := #directional.
	state
		outerCosCutoff: -1.0;
		innerCosCutoff: -1.0
]

{ #category : #accessing }
WDSGLightSource >> extraShadowDistanceFactor [
	^ extraShadowDistanceFactor
]

{ #category : #accessing }
WDSGLightSource >> extraShadowDistanceFactor: aNumber [
	extraShadowDistanceFactor := aNumber
]

{ #category : #initialization }
WDSGLightSource >> initialize [
	super initialize.
	castShadows := false.
	outerSpotCutoff := DefaultSpotOuterCutoff.
	innerSpotCutoff := DefaultSpotInnerCutoff.
	extraShadowDistanceFactor := DefaultExtraShadowDistanceFactor.
	shadowProjectionMatrix := WMMatrix4F identity.
	state := WTLightSourceData new.
	state
		intensity: Color white asWMVector4F;
		radius: 3.0.
	self point.
]

{ #category : #accessing }
WDSGLightSource >> innerSpotCutoff [
	^ innerSpotCutoff
]

{ #category : #accessing }
WDSGLightSource >> innerSpotCutoff: anObject [
	innerSpotCutoff := anObject.
	self isSpotLight ifTrue: [ 
		state innerCosCutoff: innerSpotCutoff degreeCos.
	]
]

{ #category : #accessing }
WDSGLightSource >> isDirectionalLight [
	^ type == #directional
]

{ #category : #testing }
WDSGLightSource >> isLightSource [
	^ true
]

{ #category : #accessing }
WDSGLightSource >> isPointLight [
	^ type == #point
]

{ #category : #accessing }
WDSGLightSource >> isShadowCasting [
	^ castShadows and: [ self isSpotLight or: [ self isDirectionalLight ] ]
]

{ #category : #accessing }
WDSGLightSource >> isSpotLight [
	^ type == #spot
]

{ #category : #'shadow mapping' }
WDSGLightSource >> lightRenderingStateClass [
	castShadows ifFalse: [ ^ WDSGNonShadowingLightRenderingState ].
	
	self isSpotLight ifTrue: [ ^ WDSGSpotLightRenderingState ].
	self isDirectionalLight ifTrue: [ ^ WDSGCascadeDirectionalLightRenderingState ].
	^ WDSGNonShadowingLightRenderingState
]

{ #category : #accessing }
WDSGLightSource >> outerSpotCutoff [
	^ outerSpotCutoff
]

{ #category : #accessing }
WDSGLightSource >> outerSpotCutoff: anObject [
	outerSpotCutoff := anObject.
	self isSpotLight ifTrue: [ 
		state outerCosCutoff: outerSpotCutoff degreeCos.
	].


]

{ #category : #accessing }
WDSGLightSource >> point [
	type := #point.
	state
		outerCosCutoff: -1.0;
		innerCosCutoff: -1.0
]

{ #category : #'shadow mapping' }
WDSGLightSource >> setupRenderingWithShadowMap: shadowMapIndex mainCamera: mainCamera engine: engine [
	^ self lightRenderingStateClass new
		light: self;
		mainCamera: mainCamera;
		engine: engine;
		setupShadowMapWithIndex: shadowMapIndex;
		yourself
]

{ #category : #'as yet unclassified' }
WDSGLightSource >> shadowLayerCount [
	self isSpotLight ifTrue: [ ^ 1 ].
	self isDirectionalLight ifTrue: [ ^ 3 ].
	^ 0
]

{ #category : #accessing }
WDSGLightSource >> spot [
	type := #spot.
	state
		outerCosCutoff: outerSpotCutoff degreeCos;
		innerCosCutoff: innerSpotCutoff degreeCos
]

{ #category : #accessing }
WDSGLightSource >> state [
	^ state
]

{ #category : #'shadow mapping' }
WDSGLightSource >> viewStateForRenderingState: renderingState cameraTransform: cameraTransform [
	| result |
	result := state copy.
	result shadowMapLayer: -1.0.
	type == #directional ifTrue: [
		result direction: (cameraTransform inverseTransformVector3: (renderTransform transformVector3: (WMVector3F z: 1.0))).
	] ifFalse: [
		result position: (cameraTransform inverseTransformPosition3: renderTransform translation).
	].

	type == #spot ifTrue: [ 
		result spotDirection: (cameraTransform inverseTransformVector3: (renderTransform transformVector3: (WMVector3F z: 1.0))).
	].

	^ result
]
