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
	exponent := anObject
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
	innerCutOffAngle := anObject
]

{ #category : #testing }
WDESpotLightSourceVisualComponent >> isSpotLightSourceVisualComponent [
	^ true
]

{ #category : #initialization }
WDESpotLightSourceVisualComponent >> loadFromJson: jsonData [
	super loadFromJson: jsonData.
	outerCutOffAngle := jsonData at: 'outerCutOffAngle' ifAbsent: [ outerCutOffAngle ].
	innerCutOffAngle := jsonData at: 'innerCutOffAngle' ifAbsent: [ innerCutOffAngle ].
	exponent := jsonData at: 'exponent' ifAbsent: [ exponent ].
]

{ #category : #accessing }
WDESpotLightSourceVisualComponent >> outerCutOffAngle [
	^ outerCutOffAngle
]

{ #category : #accessing }
WDESpotLightSourceVisualComponent >> outerCutOffAngle: anObject [
	outerCutOffAngle := anObject
]
