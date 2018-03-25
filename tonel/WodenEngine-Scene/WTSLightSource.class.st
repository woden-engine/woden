"
I represent a light source in the Woden scene graph.
"
Class {
	#name : #WTSLightSource,
	#superclass : #WTSNode,
	#instVars : [
		'state',
		'type',
		'castShadows',
		'shadowProjectionMatrix',
		'outerSpotCutoff',
		'innerSpotCutoff'
	],
	#classVars : [
		'DefaultSpotInnerCutoff',
		'DefaultSpotOuterCutoff'
	],
	#category : 'WodenEngine-Scene-Graph'
}

{ #category : #initialization }
WTSLightSource class >> initialize [
	super initialize.
	
	DefaultSpotOuterCutoff := 45.
	DefaultSpotInnerCutoff := 40.
]

{ #category : #accessing }
WTSLightSource >> castShadows [
	^ castShadows
]

{ #category : #accessing }
WTSLightSource >> castShadows: anObject [
	castShadows := anObject
]

{ #category : #'as yet unclassified' }
WTSLightSource >> computeShadowMapMatrixForCameraTransform: cameraTransform engine: engine [
	shadowProjectionMatrix := (WMMatrix4F reverseDepthPerspectiveFovY: outerSpotCutoff * 2.0 aspect: 1.0 near: 0.01 far: 30.0 invertedY: engine projectionInvertedY).

	^ shadowProjectionMatrix * renderTransform inverseMatrix4 * cameraTransform matrix4
]

{ #category : #accessing }
WTSLightSource >> directional [
	type := #directional.
	state
		outerCosCutoff: -1.0;
		innerCosCutoff: -1.0
]

{ #category : #initialization }
WTSLightSource >> initialize [
	super initialize.
	castShadows := false.
	outerSpotCutoff := DefaultSpotOuterCutoff.
	innerSpotCutoff := DefaultSpotInnerCutoff.
	state := WTLightSourceData new.
	state
		intensity: Color white asWMVector4F;
		radius: 3.0.
	self point.
]

{ #category : #accessing }
WTSLightSource >> innerSpotCutoff [
	^ innerSpotCutoff
]

{ #category : #accessing }
WTSLightSource >> innerSpotCutoff: anObject [
	innerSpotCutoff := anObject.
	self isSpotLight ifTrue: [ 
		state innerCosCutoff: innerSpotCutoff degreeCos.
	]
]

{ #category : #accessing }
WTSLightSource >> isDirectionalLight [
	^ type == #directional
]

{ #category : #testing }
WTSLightSource >> isLightSource [
	^ true
]

{ #category : #accessing }
WTSLightSource >> isPointLight [
	^ type == #point
]

{ #category : #accessing }
WTSLightSource >> isSpotLight [
	^ type == #spot
]

{ #category : #accessing }
WTSLightSource >> outerSpotCutoff [
	^ outerSpotCutoff
]

{ #category : #accessing }
WTSLightSource >> outerSpotCutoff: anObject [
	outerSpotCutoff := anObject.
	self isSpotLight ifTrue: [ 
		state outerCosCutoff: outerSpotCutoff degreeCos.
	].


]

{ #category : #accessing }
WTSLightSource >> point [
	type := #point.
	state
		outerCosCutoff: -1.0;
		innerCosCutoff: -1.0
]

{ #category : #accessing }
WTSLightSource >> spot [
	type := #spot.
	state
		outerCosCutoff: outerSpotCutoff degreeCos;
		innerCosCutoff: innerSpotCutoff degreeCos
]

{ #category : #accessing }
WTSLightSource >> state [
	^ state
]

{ #category : #'as yet unclassified' }
WTSLightSource >> viewStateFor: cameraTansform engine: engine shadowMapIndex: shadowMapIndex [
	| result |
	result := state copy.
	result
		shadowMapLayer: shadowMapIndex asFloat.
	type == #directional ifTrue: [
		result direction: (cameraTansform inverseTransformVector3: (renderTransform transformVector3: (WMVector3F z: 1.0))).
	] ifFalse: [
		result position: (cameraTansform inverseTransformPosition3: renderTransform translation).
	].

	type == #spot ifTrue: [ 
		result spotDirection: (cameraTansform inverseTransformVector3: (renderTransform transformVector3: (WMVector3F z: 1.0))).
		shadowMapIndex >= 0.0 ifTrue: [
			result
				shadowMapTransform: (self computeShadowMapMatrixForCameraTransform: cameraTansform engine: engine)
		]
	].

	^ result
]

{ #category : #'as yet unclassified' }
WTSLightSource >> viewportForShadowMap: renderTarget camera: camera [
	^ self viewportForShadowMap: renderTarget camera: camera submode: #full
]

{ #category : #'as yet unclassified' }
WTSLightSource >> viewportForShadowMap: renderTarget camera: camera submode: submode [
	| cameraState |
	cameraState := WTCameraState new.
	cameraState
		projectionMatrix: shadowProjectionMatrix.

	^ WTSViewport new
		camera: self;
		cameraState: cameraState;
		renderTarget: renderTarget;
		resolveRenderTarget: renderTarget;
		bounds: renderTarget bounds;
		submode: submode
]
