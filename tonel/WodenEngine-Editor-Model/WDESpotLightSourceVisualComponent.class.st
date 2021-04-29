Class {
	#name : #WDESpotLightSourceVisualComponent,
	#superclass : #WDEPointLightSourceVisualComponent,
	#instVars : [
		'innerCutOffAngle',
		'outerCutOffAngle',
		'exponent'
	],
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #visiting }
WDESpotLightSourceVisualComponent >> accept: visitor [
	^ visitor visitSpotLightSourceVisualComponent: self
]

{ #category : #accessing }
WDESpotLightSourceVisualComponent >> buildLevelElementPropertyPageWith: builder [
	super buildLevelElementPropertyPageWith: builder.
	
	builder
		scalarPropertyNamed: 'Spot Inner Angle' selector: #innerCutOffAngle;
		scalarPropertyNamed: 'Spot Outer Angle' selector: #outerCutOffAngle;
		scalarPropertyNamed: 'Spot Exponent' selector: #exponent
]

{ #category : #'as yet unclassified' }
WDESpotLightSourceVisualComponent >> createEntitySystemComponentWithTransform: componentTransform for: gameEntity [
	^ (super createEntitySystemComponentWithTransform: componentTransform for: gameEntity)
		innerCutOffAngle: self innerCutOffAngle;
		outerCutOffAngle: self outerCutOffAngle;
		yourself
]

{ #category : #serialization }
WDESpotLightSourceVisualComponent >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#outerCutOffAngle . outerCutOffAngle.
		#innerCutOffAngle . innerCutOffAngle.
		#exponent . exponent.
	}
]

{ #category : #accessing }
WDESpotLightSourceVisualComponent >> exponent [
	^ exponent
]

{ #category : #accessing }
WDESpotLightSourceVisualComponent >> exponent: anObject [
	exponent := anObject.
	self changed.
]

{ #category : #initialization }
WDESpotLightSourceVisualComponent >> initialize [
	super initialize.
	outerCutOffAngle := 45.
	innerCutOffAngle := 45.
	exponent := 1.0.
]

{ #category : #accessing }
WDESpotLightSourceVisualComponent >> innerCutOffAngle [
	^ innerCutOffAngle
]

{ #category : #accessing }
WDESpotLightSourceVisualComponent >> innerCutOffAngle: anObject [
	innerCutOffAngle := anObject.
	self changed.
]

{ #category : #testing }
WDESpotLightSourceVisualComponent >> isSpotLightSourceVisualComponent [
	^ true
]

{ #category : #initialization }
WDESpotLightSourceVisualComponent >> loadFromJson: jsonData context: context [
	super loadFromJson: jsonData context: context.
	outerCutOffAngle := jsonData at: 'outerCutOffAngle' ifAbsent: [ outerCutOffAngle ].
	innerCutOffAngle := jsonData at: 'innerCutOffAngle' ifAbsent: [ innerCutOffAngle ].
	exponent := jsonData at: 'exponent' ifAbsent: [ exponent ].
]

{ #category : #'instance creation' }
WDESpotLightSourceVisualComponent >> newGameLightSourceComponent [
	^ WDESSpotLightSourceSceneNodeComponent new
]

{ #category : #accessing }
WDESpotLightSourceVisualComponent >> outerCutOffAngle [
	^ outerCutOffAngle
]

{ #category : #accessing }
WDESpotLightSourceVisualComponent >> outerCutOffAngle: anObject [
	outerCutOffAngle := anObject.
	self changed.
]
