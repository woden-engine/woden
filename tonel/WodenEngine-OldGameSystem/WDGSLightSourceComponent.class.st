Class {
	#name : #WDGSLightSourceComponent,
	#superclass : #WDGSComponent,
	#instVars : [
		'intensity',
		'type',
		'outerSpotCutoff',
		'innerSpotCutoff'
	],
	#classVars : [
		'BrushColors'
	],
	#category : #'WodenEngine-OldGameSystem-Level'
}

{ #category : #'as yet unclassified' }
WDGSLightSourceComponent class >> jsonTypeName [
	^ 'light-source'
]

{ #category : #adding }
WDGSLightSourceComponent >> addedToEntity: anEntity [
	super addedToEntity: anEntity.
	anEntity ensureSceneNodeOfType: WDSGLightSource.
	self updateSceneNode
]

{ #category : #serialization }
WDGSLightSourceComponent >> asJsonData [
	^ OrderedDictionary newFromPairs: {
		'type' . 'light-source'.
		'light-type' . type .
		'intensity' . intensity asJsonData.
		'inner-spot-cutoff' . innerSpotCutoff .
		'outer-spot-cutoff' . outerSpotCutoff .
	 }
]

{ #category : #accessing }
WDGSLightSourceComponent >> bucket [
	^ #'light-source'
]

{ #category : #accessing }
WDGSLightSourceComponent >> directional [
	self type: #direction
]

{ #category : #initialization }
WDGSLightSourceComponent >> initialize [
	super initialize.
	intensity := Float32x4 x: 1.0 y: 1.0 z: 1.0 w: 1.0.
	type := #point.
	outerSpotCutoff := 90.0.
	innerSpotCutoff := 80.0.
]

{ #category : #accessing }
WDGSLightSourceComponent >> innerSpotCutoff [
	^ innerSpotCutoff
]

{ #category : #accessing }
WDGSLightSourceComponent >> innerSpotCutoff: anObject [
	innerSpotCutoff := anObject.
	self updateSceneNode
]

{ #category : #accessing }
WDGSLightSourceComponent >> intensity [
	^ intensity
]

{ #category : #accessing }
WDGSLightSourceComponent >> intensity: anObject [
	intensity := anObject.
	self updateSceneNode
]

{ #category : #testing }
WDGSLightSourceComponent >> isSingleton [
	^ true
]

{ #category : #serialization }
WDGSLightSourceComponent >> loadFromJson: jsonData [
	jsonData at: 'intensity' ifPresent: [ :jsonIntensity |
		intensity := Float32x4 loadFromJson: jsonIntensity
	].

	type := (jsonData at: 'light-type' ifAbsent: [ #point ]) asSymbol.
	outerSpotCutoff := (jsonData at: 'outer-spot-cutoff' ifAbsent: [ 90.0 ]).
	innerSpotCutoff := (jsonData at: 'inner-spot-cutoff' ifAbsent: [ 80.0 ]).
]

{ #category : #accessing }
WDGSLightSourceComponent >> outerSpotCutoff [
	^ outerSpotCutoff
]

{ #category : #accessing }
WDGSLightSourceComponent >> outerSpotCutoff: anObject [
	outerSpotCutoff := anObject.
	self updateSceneNode
]

{ #category : #accessing }
WDGSLightSourceComponent >> point [
	self type: #point
]

{ #category : #accessing }
WDGSLightSourceComponent >> spot [
	self type: #spot
]

{ #category : #accessing }
WDGSLightSourceComponent >> type [
	^ type
]

{ #category : #accessing }
WDGSLightSourceComponent >> type: anObject [
	type := anObject.
	self updateSceneNode
]

{ #category : #adding }
WDGSLightSourceComponent >> updateSceneNode [
	entity sceneNodesDo: [ :node |
		node isLightSource ifTrue: [ 
			node perform: type.
			node state
				intensity: intensity.
			type == #spot ifTrue: [ 
				node innerSpotCutoff: innerSpotCutoff;
					outerSpotCutoff: outerSpotCutoff.
			]
		]
	]
]
