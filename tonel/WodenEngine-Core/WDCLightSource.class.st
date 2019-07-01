Class {
	#name : #WDCLightSource,
	#superclass : #WDCAbstractSpatialObject,
	#instVars : [
		'type',
		'castShadows',
		'outerSpotCutoff',
		'innerSpotCutoff',
		'shadowMapDepthBiasConstant',
		'shadowMapDepthBiasSlope',
		'lightState'
	],
	#classVars : [
		'DefaultExtraShadowDistanceFactor',
		'DefaultShadowMapDepthBiasConstant',
		'DefaultShadowMapDepthBiasSlope',
		'DefaultSpotInnerCutoff',
		'DefaultSpotOuterCutoff'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Lighting'
}

{ #category : #'class initialization' }
WDCLightSource class >> initialize [	
	DefaultSpotOuterCutoff := 45.
	DefaultSpotInnerCutoff := 40.
	DefaultShadowMapDepthBiasConstant := 4.0.
	DefaultShadowMapDepthBiasSlope := 1.5.
]

{ #category : #accessing }
WDCLightSource >> castShadows [
	^ castShadows
]

{ #category : #accessing }
WDCLightSource >> castShadows: anObject [
	castShadows := anObject
]

{ #category : #accessing }
WDCLightSource >> directional [
	type := #directional.
	lightState
		outerCosCutoff: -1.0;
		innerCosCutoff: -1.0
]

{ #category : #initialization }
WDCLightSource >> initialize [
	super initialize.
	
	castShadows := false.
	outerSpotCutoff := DefaultSpotOuterCutoff.
	innerSpotCutoff := DefaultSpotInnerCutoff.
	shadowMapDepthBiasConstant := DefaultShadowMapDepthBiasConstant.
	shadowMapDepthBiasSlope := DefaultShadowMapDepthBiasSlope.
	lightState := WTLightSourceData new.
	lightState
		intensity: Color white asWMVector4F;
		radius: 3.0.
	self point.

]

{ #category : #accessing }
WDCLightSource >> innerSpotCutoff [
	^ innerSpotCutoff
]

{ #category : #accessing }
WDCLightSource >> innerSpotCutoff: anObject [
	innerSpotCutoff := anObject.
	self isSpotLight ifTrue: [ 
		lightState innerCosCutoff: innerSpotCutoff degreeCos.
	]
]

{ #category : #accessing }
WDCLightSource >> intensity [
	^ lightState intensity
]

{ #category : #accessing }
WDCLightSource >> intensity: aLightIntensity [
	^ lightState intensity: aLightIntensity
]

{ #category : #testing }
WDCLightSource >> isDirectionalLight [
	^ type == #directional
]

{ #category : #testing }
WDCLightSource >> isPointLight [
	^ type == #point
]

{ #category : #testing }
WDCLightSource >> isShadowCasting [
	^ castShadows and: [ self isSpotLight or: [ self isDirectionalLight ] ]
]

{ #category : #testing }
WDCLightSource >> isSpotLight [
	^ type == #spot
]

{ #category : #'shadow mapping' }
WDCLightSource >> lightRenderingStateClass [
	(WDCEngine shadowMappingEnabled and: [castShadows]) ifFalse: [ ^ WDCNonShadowingLightRenderingState ].
	
	self isSpotLight ifTrue: [ ^ WDCSpotLightRenderingState ].
	"self isDirectionalLight ifTrue: [ ^ WDCDirectionalLightRenderingState ]."
	self isDirectionalLight ifTrue: [ ^ WDCCascadeDirectionalLightRenderingState ].
	^ WDCNonShadowingLightRenderingState
]

{ #category : #accessing }
WDCLightSource >> outerSpotCutoff [
	^ outerSpotCutoff
]

{ #category : #accessing }
WDCLightSource >> outerSpotCutoff: anObject [
	outerSpotCutoff := anObject.
	self isSpotLight ifTrue: [ 
		lightState outerCosCutoff: outerSpotCutoff degreeCos.
	].


]

{ #category : #accessing }
WDCLightSource >> point [
	type := #point.
	lightState
		outerCosCutoff: -1.0;
		innerCosCutoff: -1.0
]

{ #category : #accessing }
WDCLightSource >> radius [
	^ lightState radius
]

{ #category : #accessing }
WDCLightSource >> radius: aNumber [
	lightState radius: aNumber
]

{ #category : #'shadow mapping' }
WDCLightSource >> shadowLayerCount [
	self isSpotLight ifTrue: [ ^ 1 ].
	self isDirectionalLight ifTrue: [ ^ 3 ].
	^ 0
]

{ #category : #accessing }
WDCLightSource >> shadowMapDepthBiasConstant [
	^ shadowMapDepthBiasConstant
]

{ #category : #accessing }
WDCLightSource >> shadowMapDepthBiasConstant: anObject [
	shadowMapDepthBiasConstant := anObject
]

{ #category : #accessing }
WDCLightSource >> shadowMapDepthBiasSlope [
	^ shadowMapDepthBiasSlope
]

{ #category : #accessing }
WDCLightSource >> shadowMapDepthBiasSlope: anObject [
	shadowMapDepthBiasSlope := anObject
]

{ #category : #accessing }
WDCLightSource >> spot [
	type := #spot.
	lightState
		outerCosCutoff: outerSpotCutoff degreeCos;
		innerCosCutoff: innerSpotCutoff degreeCos
]

{ #category : #accessing }
WDCLightSource >> state [
	^ lightState
]

{ #category : #accessing }
WDCLightSource >> state: anObject [
	lightState := anObject
]

{ #category : #'shadow mapping' }
WDCLightSource >> viewStateForRenderingState: renderingState cameraTransform: cameraTransform [
	| result |
	result := lightState copy.
	result shadowMapLayer: -1.0.
	type == #directional ifTrue: [
		result direction: (cameraTransform inverseTransformVector3: (self transform transformVector3: (WMVector3F z: 1.0))).
	] ifFalse: [
		result position: (cameraTransform inverseTransformPosition3: self transform translation).
	].

	type == #spot ifTrue: [ 
		result spotDirection: (cameraTransform inverseTransformVector3: (self transform transformVector3: (WMVector3F z: 1.0))).
	].

	^ result
]
