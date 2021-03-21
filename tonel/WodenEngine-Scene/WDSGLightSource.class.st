"
I represent a light source in the Woden scene graph.
"
Class {
	#name : #WDSGLightSource,
	#superclass : #WDSGAbstractSpatialObject,
	#instVars : [
		'renderingRenderable'
	],
	#classVars : [
		'DefaultExtraShadowDistanceFactor',
		'DefaultShadowMapDepthBiasConstant',
		'DefaultShadowMapDepthBiasSlope',
		'DefaultSpotInnerCutoff',
		'DefaultSpotOuterCutoff'
	],
	#category : #'WodenEngine-Scene-Graph'
}

{ #category : #accessing }
WDSGLightSource >> castShadows [
	^ objectState castShadows
]

{ #category : #accessing }
WDSGLightSource >> castShadows: aBoolean [
	objectState castShadows: aBoolean.
	self stateChanged
]

{ #category : #initialization }
WDSGLightSource >> createRenderingRenderable [
	renderingRenderable := WDCRenderingSceneLightSourceObject new
		node: self;
		spatialObject: objectState;
		yourself.
]

{ #category : #initialization }
WDSGLightSource >> createSpatialObjectState [
	objectState := WDCLightSource new
]

{ #category : #'light type' }
WDSGLightSource >> directional [
	objectState directional.
	self stateChanged
]

{ #category : #accessing }
WDSGLightSource >> extraShadowDistanceFactor [
	^ objectState extraShadowDistanceFactor
]

{ #category : #accessing }
WDSGLightSource >> extraShadowDistanceFactor: aNumber [
	objectState extraShadowDistanceFactor: aNumber.
	self stateChanged
]

{ #category : #initialization }
WDSGLightSource >> initialize [
	super initialize.
	self createRenderingRenderable.
]

{ #category : #accessing }
WDSGLightSource >> innerSpotCutoff [
	^ objectState innerSpotCutoff
]

{ #category : #accessing }
WDSGLightSource >> innerSpotCutoff: aNumber [
	objectState innerSpotCutoff: aNumber.
	self stateChanged
]

{ #category : #accessing }
WDSGLightSource >> intensity [
	^ objectState intensity
]

{ #category : #accessing }
WDSGLightSource >> intensity: aLightIntensity [
	objectState intensity: aLightIntensity.
	self stateChanged
]

{ #category : #testing }
WDSGLightSource >> isDirectionalLight [
	^ objectState isDirectionalLight
]

{ #category : #testing }
WDSGLightSource >> isLightSource [
	^ true
]

{ #category : #testing }
WDSGLightSource >> isPointLight [
	^ objectState isPointLight
]

{ #category : #testing }
WDSGLightSource >> isShadowCasting [
	^ objectState isShadowCasting
]

{ #category : #testing }
WDSGLightSource >> isSpotLight [
	^ objectState isSpotLight
]

{ #category : #accessing }
WDSGLightSource >> outerSpotCutoff [
	^ objectState outerSpotCutoff
]

{ #category : #accessing }
WDSGLightSource >> outerSpotCutoff: aNumber [
	objectState outerSpotCutoff: aNumber.
	self stateChanged
]

{ #category : #'light type' }
WDSGLightSource >> point [
	objectState point.
	self stateChanged
]

{ #category : #copying }
WDSGLightSource >> postCopyCommon [
	super postCopyCommon.
	self createRenderingRenderable
]

{ #category : #accessing }
WDSGLightSource >> radius: aNumber [
	objectState radius: aNumber.
	self stateChanged.
]

{ #category : #accessing }
WDSGLightSource >> renderingRenderables [
	^ { renderingRenderable }
]

{ #category : #accessing }
WDSGLightSource >> shadowMapDepthBiasConstant [
	^ objectState shadowMapDepthBiasConstant
]

{ #category : #accessing }
WDSGLightSource >> shadowMapDepthBiasConstant: aNumber [
	objectState shadowMapDepthBiasConstant: aNumber
]

{ #category : #accessing }
WDSGLightSource >> shadowMapDepthBiasSlope [
	^ objectState shadowMapDepthBiasSlope
]

{ #category : #accessing }
WDSGLightSource >> shadowMapDepthBiasSlope: aNumber [
	objectState shadowMapDepthBiasSlope: aNumber
]

{ #category : #'light type' }
WDSGLightSource >> spot [
	objectState spot.
	self stateChanged
]
