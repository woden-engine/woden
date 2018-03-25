Class {
	#name : #WTGSMap,
	#superclass : #WTGSMapNode,
	#instVars : [
		'scene',
		'entities',
		'pointEntityInstanceGroup',
		'editorMode',
		'timeListeners',
		'levelPlayer',
		'backgroundColor',
		'touchListeners'
	],
	#category : 'WodenEngine-GameSystem-Level'
}

{ #category : #serialization }
WTGSMap class >> fuelIgnoredInstanceVariableNames [
	^ #('scene')
]

{ #category : #'as yet unclassified' }
WTGSMap class >> loadJsonFromFileNamed: aFileName [
	^ self new loadJsonFromFileNamed: aFileName
]

{ #category : #adding }
WTGSMap >> addEntity: anEntity [
	entities add: anEntity.
	anEntity addedToMap: self.
	scene ifNotNil: [ anEntity addedToScene: scene ]
]

{ #category : #converting }
WTGSMap >> asJsonData [
	^ OrderedDictionary newFromPairs: {
		'background-color' . backgroundColor asWodenJsonData .
		'entities' . entities collect: #asJsonData
	 }
]

{ #category : #accessing }
WTGSMap >> backgroundColor [
	^ backgroundColor
]

{ #category : #accessing }
WTGSMap >> backgroundColor: anObject [
	backgroundColor := anObject.
	scene ifNotNil: [ 
		scene backgroundColor: backgroundColor.
	]
	
]

{ #category : #accessing }
WTGSMap >> createPointEntityInstanceGroup [
	pointEntityInstanceGroup := WTSSpatialObjectInstanceGroup new.
	pointEntityInstanceGroup
		updatedPerFrame: false;
		renderable: ((WTGenericMeshBuilder for: scene engine)
		addCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
		mesh).
	scene add: pointEntityInstanceGroup
]

{ #category : #accessing }
WTGSMap >> destroyPointEntityInstanceGroup [
	pointEntityInstanceGroup removeFromScene.
	pointEntityInstanceGroup := nil.
]

{ #category : #accessing }
WTGSMap >> editorMode [
	^ editorMode
]

{ #category : #accessing }
WTGSMap >> editorMode: anObject [
	editorMode := anObject
]

{ #category : #selection }
WTGSMap >> elementsAlongRay: ray mode: mode do: aBlock [
	entities do: [:entity | entity elementsAlongRay: ray mode: mode do: aBlock ]
]

{ #category : #accessing }
WTGSMap >> entities [
	^ entities
]

{ #category : #'as yet unclassified' }
WTGSMap >> findBrushesIntersectingBox: box [
	| brushes |
	brushes := OrderedCollection new.
	entities do: [ :entity |
		entity findBrushesIntersectingBox: box into: brushes
	].

	^ brushes
]

{ #category : #'as yet unclassified' }
WTGSMap >> findBrushesIntersectingSelectedBrushesProperly: selection [
	| candidates |
	candidates := self findBrushesIntersectingBox: selection box.
	^ candidates select: [ :brush |
		(selection includes: brush) not and: [ selection intersectsWithBrushProperly: brush ]
	].
]

{ #category : #initialization }
WTGSMap >> initialize [
	super initialize.
	entities := OrderedCollection new.
	editorMode := false.
	timeListeners := Set new.
	touchListeners := Set new.
	backgroundColor := Color veryDarkGray.
]

{ #category : #accessing }
WTGSMap >> levelPlayer [
	^ levelPlayer
]

{ #category : #accessing }
WTGSMap >> levelPlayer: anObject [
	levelPlayer := anObject
]

{ #category : #serialization }
WTGSMap >> loadFromJson: jsonData [
	jsonData at: 'background-color' ifPresent: [ :colorJson |
		backgroundColor := Color loadWodenJsonData: colorJson
	].

	jsonData at: 'entities' ifPresent: [ :entitiesJson |
		entitiesJson do: [:entityJson | self addEntity: (WTGSEntity loadFromJson: entityJson) ] 
	]
]

{ #category : #'as yet unclassified' }
WTGSMap >> loadJsonFromFileNamed: aFileName [
	^ self loadFromJson: (NeoJSONReader fromString: aFileName asFileReference contents)
]

{ #category : #'resource loading' }
WTGSMap >> loadMaterial: aMaterialName [
	| engine |
	engine := scene engine.
	
	^ engine resourceCache loadMaterial: aMaterialName fallback: [ engine resourceCache defaultMaterial ]
]

{ #category : #accessing }
WTGSMap >> numberOfEntities [
	^ entities size
]

{ #category : #'as yet unclassified' }
WTGSMap >> playModeCopy [
	| result copiedDictionary |
	result := self class new.
	copiedDictionary := Dictionary new.
	entities do: [ :ent | result addEntity: (ent playModeCopyWith: copiedDictionary) ].
	^ result
]

{ #category : #accessing }
WTGSMap >> pointEntityInstanceGroup [
	^ pointEntityInstanceGroup
]

{ #category : #'as yet unclassified' }
WTGSMap >> registerTimeListener: aTimeListener [
	timeListeners add: aTimeListener
]

{ #category : #'as yet unclassified' }
WTGSMap >> registerTouchListener: aTouchListener [
	touchListeners add: aTouchListener
]

{ #category : #adding }
WTGSMap >> removeEntity: anEntity [
	entities remove: anEntity.
	(touchListeners includes: anEntity) ifTrue: [ touchListeners remove: anEntity ].
	scene ifNotNil: [ anEntity removedFromScene: scene ].
	anEntity removedFromMap: self.
]

{ #category : #'as yet unclassified' }
WTGSMap >> saveBinaryToFile: fileName [
	FLSerializer serialize: self toFileNamed: fileName.
]

{ #category : #'as yet unclassified' }
WTGSMap >> saveJsonToFile: fileName [
	self saveJsonToFile: fileName prettyPrint: true
]

{ #category : #'as yet unclassified' }
WTGSMap >> saveJsonToFile: fileName prettyPrint: prettyPrint [
	fileName asFileReference writeStreamDo: [ :out |
		out truncate.
		(NeoJSONWriter on: out)
			prettyPrint: prettyPrint;
			nextPut: self asJsonData
	].

]

{ #category : #accessing }
WTGSMap >> scene [
	^ scene
]

{ #category : #accessing }
WTGSMap >> scene: anObject [
	scene ifNotNil: [
		self destroyPointEntityInstanceGroup
		entities do: [ :entity | entity removedFromScene: scene ]
	]. 
	scene := anObject.
	scene ifNotNil: [
		scene backgroundColor: backgroundColor.
		self createPointEntityInstanceGroup.
		entities do: [ :entity | entity addedToScene: scene ]
	]
]

{ #category : #rendering }
WTGSMap >> sendTouchEvents [
	| firstBox secondBox |
	self flag: 'Use a proper no always O(n^2) algorithm, or use the physics engine for this'.
	touchListeners do: [ :a |		
		firstBox := a boundingBox.
		touchListeners do: [ :b |
			a ~~ b ifTrue: [
 				secondBox := b boundingBox.
				(firstBox intersectsOrContainsBox: secondBox) ifTrue: [
					a touch: b.
					b touch: a
				] 
			]
		]
	]
]

{ #category : #rendering }
WTGSMap >> simulateTime: delta [
	timeListeners do: [ :listener | listener simulateTime: delta ].
	self sendTouchEvents.
]

{ #category : #'menu messages' }
WTGSMap >> spawn [
	entities do: #spawn
]

{ #category : #spawning }
WTGSMap >> spawnEntityWithBehavior: behavior position: aPosition [
	| entity |
	entity := WTGSEntity new.
	entity
		addComponent: (WTGSSpatialDescription new translation: aPosition);
		addComponent: behavior.
	self addEntity: entity.
	entity spawn.
	^ entity
]

{ #category : #'as yet unclassified' }
WTGSMap >> unregisterTimeListener: aTimeListener [
	timeListeners remove: aTimeListener
]

{ #category : #'as yet unclassified' }
WTGSMap >> unregisterTouchListener: aTouchListener [
	touchListeners add: aTouchListener
]
