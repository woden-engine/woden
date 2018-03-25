Class {
	#name : #WTGSLightSourceComponent,
	#superclass : #WTGSComponent,
	#instVars : [
		'intensity',
		'type',
		'outerSpotCutoff',
		'innerSpotCutoff'
	],
	#classVars : [
		'BrushColors'
	],
	#category : 'WodenEngine-GameSystem-Level'
}

{ #category : #'as yet unclassified' }
WTGSLightSourceComponent class >> jsonTypeName [
	^ 'light-source'
]

{ #category : #adding }
WTGSLightSourceComponent >> addedToEntity: anEntity [
	super addedToEntity: anEntity.
	anEntity ensureSceneNodeOfType: WTSLightSource.
	self updateSceneNode
]

{ #category : #serialization }
WTGSLightSourceComponent >> asJsonData [
	^ OrderedDictionary newFromPairs: {
		'type' . 'light-source'.
		'light-type' . type .
		'intensity' . intensity asJsonData.
		'inner-spot-cutoff' . innerSpotCutoff .
		'outer-spot-cutoff' . outerSpotCutoff .
	 }
]

{ #category : #accessing }
WTGSLightSourceComponent >> bucket [
	^ #'light-source'
]

{ #category : #accessing }
WTGSLightSourceComponent >> directional [
	self type: #direction
]

{ #category : #initialization }
WTGSLightSourceComponent >> initialize [
	super initialize.
	intensity := WMVector4F x: 1.0 y: 1.0 z: 1.0 w: 1.0.
	type := #point.
	outerSpotCutoff := 90.0.
	innerSpotCutoff := 80.0.
]

{ #category : #accessing }
WTGSLightSourceComponent >> innerSpotCutoff [
	^ innerSpotCutoff
]

{ #category : #accessing }
WTGSLightSourceComponent >> innerSpotCutoff: anObject [
	innerSpotCutoff := anObject.
	self updateSceneNode
]

{ #category : #accessing }
WTGSLightSourceComponent >> intensity [
	^ intensity
]

{ #category : #accessing }
WTGSLightSourceComponent >> intensity: anObject [
	intensity := anObject.
	self updateSceneNode
]

{ #category : #testing }
WTGSLightSourceComponent >> isSingleton [
	^ true
]

{ #category : #serialization }
WTGSLightSourceComponent >> loadFromJson: jsonData [
	jsonData at: 'intensity' ifPresent: [ :jsonIntensity |
		intensity := WMVector4F loadFromJson: jsonIntensity
	].

	type := (jsonData at: 'light-type' ifAbsent: [ #point ]) asSymbol.
	outerSpotCutoff := (jsonData at: 'outer-spot-cutoff' ifAbsent: [ 90.0 ]).
	innerSpotCutoff := (jsonData at: 'inner-spot-cutoff' ifAbsent: [ 80.0 ]).
]

{ #category : #accessing }
WTGSLightSourceComponent >> outerSpotCutoff [
	^ outerSpotCutoff
]

{ #category : #accessing }
WTGSLightSourceComponent >> outerSpotCutoff: anObject [
	outerSpotCutoff := anObject.
	self updateSceneNode
]

{ #category : #accessing }
WTGSLightSourceComponent >> point [
	self type: #point
]

{ #category : #accessing }
WTGSLightSourceComponent >> spot [
	self type: #spot
]

{ #category : #accessing }
WTGSLightSourceComponent >> type [
	^ type
]

{ #category : #accessing }
WTGSLightSourceComponent >> type: anObject [
	type := anObject.
	self updateSceneNode
]

{ #category : #adding }
WTGSLightSourceComponent >> updateSceneNode [
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
