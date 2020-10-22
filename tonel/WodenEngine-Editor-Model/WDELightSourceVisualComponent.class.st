Class {
	#name : #WDELightSourceVisualComponent,
	#superclass : #WDEPunctualVisualComponent,
	#instVars : [
		'color',
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
		linearColor3PropertyNamed: 'Color' selector: #color;
		scalarPropertyNamed: 'Intensity' selector: #intensity min: 0.0
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

{ #category : #accessing }
WDELightSourceVisualComponent >> color [
	^ color
]

{ #category : #accessing }
WDELightSourceVisualComponent >> color: anObject [
	color := anObject implicitCastTo: Float32x3.
	self changed.
]

{ #category : #'as yet unclassified' }
WDELightSourceVisualComponent >> coloredIntensity [
	^ color * intensity
]

{ #category : #serialization }
WDELightSourceVisualComponent >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#color . color encodeForJSON.
		#intensity . intensity.
		#castShadows . castShadows.
	}
]

{ #category : #initialization }
WDELightSourceVisualComponent >> initialize [
	super initialize.
	color := Float32x3 ones.
	intensity := 1.0.
	castShadows := false.
]

{ #category : #accessing }
WDELightSourceVisualComponent >> intensity [
	^ intensity
]

{ #category : #accessing }
WDELightSourceVisualComponent >> intensity: anObject [
	intensity := anObject asFloat.
	self changed.
]

{ #category : #testing }
WDELightSourceVisualComponent >> isLightSourceVisualComponent [
	^ true
]

{ #category : #serialization }
WDELightSourceVisualComponent >> loadFromJson: jsonData [
	super loadFromJson: jsonData.
	color := Float32x3 loadFromJson: (jsonData at: 'color').
	intensity := (jsonData at: 'intensity' ifAbsent: [intensity]) asFloat.
	castShadows := jsonData at: 'castShadows' ifAbsent: [castShadows].

]
