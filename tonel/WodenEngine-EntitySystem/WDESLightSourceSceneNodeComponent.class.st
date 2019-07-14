Class {
	#name : #WDESLightSourceSceneNodeComponent,
	#superclass : #WDESAbstractSceneNodeComponent,
	#instVars : [
		'intensity',
		'radius',
		'castShadows'
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
		intensity: intensity.
	^ node
]

{ #category : #initialization }
WDESLightSourceSceneNodeComponent >> initialize [
	super initialize.
	intensity := Color white asWMVector4F.
	radius := 3.0.
	castShadows := false.
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
