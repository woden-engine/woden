Class {
	#name : #WDESLightSourceSceneNodeComponent,
	#superclass : #WDESAbstractSceneNodeComponent,
	#instVars : [
		'intensity',
		'radius',
		'castShadows',
		'shadowMapDepthBiasConstant',
		'shadowMapDepthBiasSlope'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #accessing }
WDESLightSourceSceneNodeComponent >> castShadows [
	^ castShadows
]

{ #category : #accessing }
WDESLightSourceSceneNodeComponent >> castShadows: aBoolean [
	castShadows := aBoolean.
	sceneNode ifNotNil: [ sceneNode castShadows: aBoolean ]
]

{ #category : #accessing }
WDESLightSourceSceneNodeComponent >> createSceneNode [
	| node |
	node := WDSGLightSource new.
	node radius: radius;
		castShadows: castShadows;
		intensity: intensity;
		shadowMapDepthBiasConstant: shadowMapDepthBiasConstant;
		shadowMapDepthBiasSlope: shadowMapDepthBiasSlope.
	^ node
]

{ #category : #initialization }
WDESLightSourceSceneNodeComponent >> initialize [
	super initialize.
	intensity := Color white asFloat32x4.
	radius := 3.0.
	castShadows := false.
	shadowMapDepthBiasConstant := WDCLightSource defaultShadowMapDepthBiasConstant.
	shadowMapDepthBiasSlope := WDCLightSource defaultShadowMapDepthBiasSlope.
]

{ #category : #accessing }
WDESLightSourceSceneNodeComponent >> intensity [
	^ intensity
]

{ #category : #accessing }
WDESLightSourceSceneNodeComponent >> intensity: aColoredIntensity [
	intensity := aColoredIntensity.
	sceneNode ifNotNil: [ sceneNode intensity: aColoredIntensity ].
]

{ #category : #accessing }
WDESLightSourceSceneNodeComponent >> radius [
	^ radius
]

{ #category : #accessing }
WDESLightSourceSceneNodeComponent >> radius: aFloat [
	radius := aFloat.
	sceneNode ifNotNil: [ sceneNode radius: aFloat ].
]

{ #category : #accessing }
WDESLightSourceSceneNodeComponent >> shadowMapDepthBiasConstant: aNumber [
	shadowMapDepthBiasConstant := aNumber.
	sceneNode ifNotNil: [ sceneNode shadowMapDepthBiasConstant: aNumber ].
]

{ #category : #accessing }
WDESLightSourceSceneNodeComponent >> shadowMapDepthBiasSlope: aNumber [
	shadowMapDepthBiasSlope := aNumber.
	sceneNode ifNotNil: [ sceneNode shadowMapDepthBiasSlope: aNumber ].
]
