Class {
	#name : #WDGSMap,
	#superclass : #WDGSMapNode,
	#instVars : [
		'scene',
		'entities',
		'pointEntityInstanceGroup',
		'editorMode',
		'timeListeners',
		'levelPlayer',
		'backgroundColor',
		'touchListeners',
		'dynamicsWorld',
		'prePhysicstimeListeners',
		'physicsWorldDebugDrawingSceneNode'
	],
	#category : #'WodenEngine-OldGameSystem-Level'
}

{ #category : #serialization }
WDGSMap class >> fuelIgnoredInstanceVariableNames [
	^ #('scene')
]

{ #category : #'as yet unclassified' }
WDGSMap class >> loadJsonFromFileNamed: aFileName [
	^ self new loadJsonFromFileNamed: aFileName
]

{ #category : #adding }
WDGSMap >> addEntity: anEntity [
	entities add: anEntity.
	anEntity addedToMap: self.
	scene ifNotNil: [ anEntity addedToScene: scene ]
]

{ #category : #converting }
WDGSMap >> asJsonData [
	^ OrderedDictionary newFromPairs: {
		'background-color' . backgroundColor asWodenJsonData .
		'entities' . entities collect: #asJsonData
	 }
]

{ #category : #accessing }
WDGSMap >> backgroundColor [
	^ backgroundColor
]

{ #category : #accessing }
WDGSMap >> backgroundColor: anObject [
	backgroundColor := anObject.
	scene ifNotNil: [ 
		scene backgroundColor: backgroundColor.
	]
	
]

{ #category : #factory }
WDGSMap >> createDynamicsWorld [
	| world |
	world := WDPhyPhysicsEngine current createDynamicsWorld.
	world gravity: (Float32x3 x: 0.0 y: -9.8 z: 0.0).
	physicsWorldDebugDrawingSceneNode := WDSGSpatialObject new.
	physicsWorldDebugDrawingSceneNode
		makeTranslucentSorted;
		visible: false;
		renderable: (WDPhyDebugDrawingRenderable new
			engine: self engine;
			physicsWorld: world).
	scene add: physicsWorldDebugDrawingSceneNode.
	
	^ world
]

{ #category : #spawning }
WDGSMap >> createEntityWithBehavior: behavior position: aPosition [
	| entity |
	entity := WDGSEntity new.
	entity
		addComponent: (WDGSSpatialDescription new translation: aPosition);
		addComponent: behavior.
	self addEntity: entity.
	^ entity
]

{ #category : #accessing }
WDGSMap >> createPointEntityInstanceGroup [

	| solidColorMaterial |
	solidColorMaterial := self engine resourceCache loadMaterial: 'materials/basic/flat.json'.
	
	pointEntityInstanceGroup := WDSGSpatialObjectInstanceGroup new.
	pointEntityInstanceGroup
		updatedPerFrame: false;
		renderable: (WDCRenderableWithAlternatives new
			addDefaultAlternative:((WDCGenericMeshBuilder for: scene engine)
				addCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
				mesh);
			addAlternative:((WDCGenericMeshBuilder for: scene engine)
				currentMaterial: solidColorMaterial;
				addWireCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
				mesh) submode: #wire;
				yourself).
	scene add: pointEntityInstanceGroup
]

{ #category : #accessing }
WDGSMap >> destroyPointEntityInstanceGroup [
	pointEntityInstanceGroup removeFromScene.
	pointEntityInstanceGroup := nil.
]

{ #category : #physics }
WDGSMap >> dynamicsWorld [
	^ dynamicsWorld
]

{ #category : #accessing }
WDGSMap >> editorMode [
	^ editorMode
]

{ #category : #accessing }
WDGSMap >> editorMode: anObject [
	editorMode := anObject
]

{ #category : #selection }
WDGSMap >> elementsAlongRay: ray mode: mode do: aBlock [
	entities do: [:entity | entity elementsAlongRay: ray mode: mode do: aBlock ]
]

{ #category : #accessing }
WDGSMap >> entities [
	^ entities
]

{ #category : #'as yet unclassified' }
WDGSMap >> findBrushesIntersectingBox: box [
	| brushes |
	brushes := OrderedCollection new.
	entities do: [ :entity |
		entity findBrushesIntersectingBox: box into: brushes
	].

	^ brushes
]

{ #category : #'as yet unclassified' }
WDGSMap >> findBrushesIntersectingSelectedBrushesProperly: selection [
	| candidates |
	candidates := self findBrushesIntersectingBox: selection box.
	^ candidates select: [ :brush |
		(selection includes: brush) not and: [ selection intersectsWithBrushProperly: brush ]
	].
]

{ #category : #initialization }
WDGSMap >> initialize [
	super initialize.
	entities := OrderedCollection new.
	editorMode := false.
	prePhysicstimeListeners := Set new.
	timeListeners := Set new.
	touchListeners := Set new.
	backgroundColor := Color black
]

{ #category : #accessing }
WDGSMap >> levelPlayer [
	^ levelPlayer
]

{ #category : #accessing }
WDGSMap >> levelPlayer: anObject [
	levelPlayer := anObject
]

{ #category : #serialization }
WDGSMap >> loadFromJson: jsonData [
	jsonData at: 'background-color' ifPresent: [ :colorJson |
		backgroundColor := Color loadWodenJsonData: colorJson
	].

	jsonData at: 'entities' ifPresent: [ :entitiesJson |
		entitiesJson do: [:entityJson | self addEntity: (WDGSEntity loadFromJson: entityJson) ] 
	]
]

{ #category : #'as yet unclassified' }
WDGSMap >> loadJsonFromFileNamed: aFileName [
	^ self loadFromJson: (NeoJSONReader fromString: aFileName asFileReference contents)
]

{ #category : #'resource loading' }
WDGSMap >> loadMaterial: aMaterialName [
	| engine |
	engine := scene engine.
	
	^ engine resourceCache loadMaterial: aMaterialName fallback: [ engine resourceCache defaultMaterial ]
]

{ #category : #accessing }
WDGSMap >> numberOfEntities [
	^ entities size
]

{ #category : #playing }
WDGSMap >> play [
	^ (WDAGSLevelModel for: self engine)
		map: self;
		spawn;
		open
]

{ #category : #'as yet unclassified' }
WDGSMap >> playModeCopy [
	| result copiedDictionary |
	result := self class new.
	copiedDictionary := Dictionary new.
	entities do: [ :ent | result addEntity: (ent playModeCopyWith: copiedDictionary) ].
	^ result
]

{ #category : #accessing }
WDGSMap >> pointEntityInstanceGroup [
	^ pointEntityInstanceGroup
]

{ #category : #'as yet unclassified' }
WDGSMap >> registerPrePhysicsTimeListener: aTimeListener [
	prePhysicstimeListeners add: aTimeListener
]

{ #category : #'as yet unclassified' }
WDGSMap >> registerTimeListener: aTimeListener [
	timeListeners add: aTimeListener
]

{ #category : #'as yet unclassified' }
WDGSMap >> registerTouchListener: aTouchListener [
	touchListeners add: aTouchListener
]

{ #category : #adding }
WDGSMap >> removeEntity: anEntity [
	entities remove: anEntity.
	(touchListeners includes: anEntity) ifTrue: [ touchListeners remove: anEntity ].
	scene ifNotNil: [ anEntity removedFromScene: scene ].
	anEntity removedFromMap: self.
]

{ #category : #'as yet unclassified' }
WDGSMap >> saveBinaryToFile: fileName [
	FLSerializer serialize: self toFileNamed: fileName.
]

{ #category : #'as yet unclassified' }
WDGSMap >> saveJsonToFile: fileName [
	self saveJsonToFile: fileName prettyPrint: true
]

{ #category : #'as yet unclassified' }
WDGSMap >> saveJsonToFile: fileName prettyPrint: prettyPrint [
	fileName asFileReference writeStreamDo: [ :out |
		out truncate.
		(NeoJSONWriter on: out)
			prettyPrint: prettyPrint;
			nextPut: self asJsonData
	].

]

{ #category : #accessing }
WDGSMap >> scene [
	^ scene
]

{ #category : #accessing }
WDGSMap >> scene: anObject [
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
WDGSMap >> sendTouchEvents [
	| firstBox secondBox |
	self flag: 'Use a proper no always O(n^2) algorithm, or use the physics engine for this'.
	touchListeners do: [ :a |		
		firstBox := a boundingBox.
		touchListeners do: [ :b |
			a ~~ b ifTrue: [
 				secondBox := b boundingBox.
				(firstBox hasIntersectionWithBox: secondBox) ifTrue: [
					a touch: b.
					b touch: a
				] 
			]
		]
	]
]

{ #category : #physics }
WDGSMap >> simulatePhysicsTime: deltaTime [
	dynamicsWorld ifNil: [ ^ self ].
	dynamicsWorld simulateTime: deltaTime.
	physicsWorldDebugDrawingSceneNode renderable ifNotNil: #invalidate
]

{ #category : #'map events' }
WDGSMap >> simulateTime: delta [
	prePhysicstimeListeners do: [ :listener | listener simulatePrePhysicsTime: delta ].
	self simulatePhysicsTime: delta.
	timeListeners do: [ :listener | listener simulateTime: delta ].
	self sendTouchEvents.
]

{ #category : #'menu messages' }
WDGSMap >> spawn [
	entities do: #spawn.
]

{ #category : #spawning }
WDGSMap >> spawnEntityWithBehavior: behavior position: aPosition [
	^ (self createEntityWithBehavior: behavior position: aPosition)
		spawn;
		yourself
]

{ #category : #'as yet unclassified' }
WDGSMap >> togglePhysicsDebugging [
	physicsWorldDebugDrawingSceneNode ifNotNil: [ physicsWorldDebugDrawingSceneNode toggleVisible ]
]

{ #category : #'as yet unclassified' }
WDGSMap >> unregisterPrePhysicsTimeListener: aTimeListener [
	prePhysicstimeListeners remove: aTimeListener
]

{ #category : #'as yet unclassified' }
WDGSMap >> unregisterTimeListener: aTimeListener [
	timeListeners remove: aTimeListener
]

{ #category : #'as yet unclassified' }
WDGSMap >> unregisterTouchListener: aTouchListener [
	touchListeners add: aTouchListener
]

{ #category : #physics }
WDGSMap >> validDynamicsWorld [
	^ dynamicsWorld ifNil: [ dynamicsWorld := self createDynamicsWorld ]
]
