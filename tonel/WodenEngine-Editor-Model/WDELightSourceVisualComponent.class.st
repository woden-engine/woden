Class {
	#name : #WDELightSourceVisualComponent,
	#superclass : #WDEPunctualVisualComponent,
	#instVars : [
		'intensity',
		'castShadows'
	],
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #visiting }
WDELightSourceVisualComponent >> accept: visitor [
	^ visitor visitLightSourceVisualComponent: self
]

{ #category : #accessing }
WDELightSourceVisualComponent >> buildLevelElementPropertyPageWith: builder [
	super buildLevelElementPropertyPageWith: builder.
	
	builder
		booleanPropertyNamed: 'Cast Shadows' selector: #castShadows;
		vector3PropertyNamed: 'Intensity' selector: #intensity
]

{ #category : #accessing }
WDELightSourceVisualComponent >> castShadows [
	^ castShadows
]

{ #category : #accessing }
WDELightSourceVisualComponent >> castShadows: anObject [
	castShadows := anObject.
	self changed.
]

{ #category : #serialization }
WDELightSourceVisualComponent >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#intensity . intensity encodeForJSON.
		#castShadows . castShadows.
	}
]

{ #category : #initialization }
WDELightSourceVisualComponent >> initialize [
	super initialize.
	intensity := Float32x3 ones.
	castShadows := false.
]

{ #category : #accessing }
WDELightSourceVisualComponent >> intensity [
	^ intensity
]

{ #category : #accessing }
WDELightSourceVisualComponent >> intensity: anObject [
	intensity := anObject.
	self changed.
]

{ #category : #testing }
WDELightSourceVisualComponent >> isLightSourceVisualComponent [
	^ true
]

{ #category : #serialization }
WDELightSourceVisualComponent >> loadFromJson: jsonData [
	super loadFromJson: jsonData.
	intensity := Float32x3 loadFromJson: (jsonData at: 'intensity').
	castShadows := jsonData at: 'castShadows' ifAbsent: [castShadows].

]
