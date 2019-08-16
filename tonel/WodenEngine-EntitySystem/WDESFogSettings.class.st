Class {
	#name : #WDESFogSettings,
	#superclass : #Object,
	#instVars : [
		'fogMode',
		'fogDensity',
		'fogColor',
		'fogStartDistance',
		'fogEndDistance',
		'farDistanceOverride'
	],
	#pools : [
		'OSKeySymbols',
		'WDESTypeNameConstants'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #accessing }
WDESFogSettings class >> defaultUnderwaterFogSettings [
	^ self new
		useExponentialFog
		fogColor: (Color fromHexString: '0E1233') asWMVector4F;
		fogDensity: 0.005;
		yourself
]

{ #category : #'as yet unclassified' }
WDESFogSettings >> applyToNode: cameraNode [
	cameraNode
		fogMode: fogMode;
		fogColor: fogColor;
		fogDensity: fogDensity;
		fogStartDistance: fogStartDistance;
		fogEndDistance: fogEndDistance.
		
	farDistanceOverride ifNil: [
		"Disable the skybox rendering."
		cameraNode
			usesSceneBackgroundLayer: true;
			backgroundColor: nil
	] ifNotNil: [
		cameraNode
			farDistance: farDistanceOverride;
			usesSceneBackgroundLayer: false;
			backgroundColor: fogColor
	]
]

{ #category : #accessing }
WDESFogSettings >> farDistanceOverride [
	^ farDistanceOverride
]

{ #category : #accessing }
WDESFogSettings >> farDistanceOverride: anObject [
	farDistanceOverride := anObject
]

{ #category : #accessing }
WDESFogSettings >> fogColor [
	^ fogColor
]

{ #category : #accessing }
WDESFogSettings >> fogColor: anObject [
	fogColor := anObject
]

{ #category : #accessing }
WDESFogSettings >> fogDensity [
	^ fogDensity
]

{ #category : #accessing }
WDESFogSettings >> fogDensity: anObject [
	fogDensity := anObject
]

{ #category : #accessing }
WDESFogSettings >> fogEndDistance [
	^ fogEndDistance
]

{ #category : #accessing }
WDESFogSettings >> fogEndDistance: anObject [
	fogEndDistance := anObject
]

{ #category : #accessing }
WDESFogSettings >> fogMode [
	^ fogMode
]

{ #category : #accessing }
WDESFogSettings >> fogMode: anObject [
	fogMode := anObject
]

{ #category : #accessing }
WDESFogSettings >> fogStartDistance [
	^ fogStartDistance
]

{ #category : #accessing }
WDESFogSettings >> fogStartDistance: anObject [
	fogStartDistance := anObject
]

{ #category : #initialization }
WDESFogSettings >> initialize [
	super initialize.
	self withoutFog.
	fogStartDistance := 0.0.
	fogEndDistance := 1.0.
	fogDensity := 0.0.
	fogColor := WMVector4F zero. 
	farDistanceOverride := nil.
]

{ #category : #fog }
WDESFogSettings >> useExponentialFog [
	fogMode := WDSGCamera fogModeExponential.
]

{ #category : #fog }
WDESFogSettings >> useExponentialSquaredFog [
	fogMode := WDSGCamera fogModeExponentialSquared.
]

{ #category : #fog }
WDESFogSettings >> useLinearFog [
	fogMode := WDSGCamera fogModeLinear.
]

{ #category : #fog }
WDESFogSettings >> withoutFog [
	fogMode := WDSGCamera fogModeNone.
]
