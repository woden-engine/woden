Class {
	#name : #WDESAbstractUniverse,
	#superclass : #WDESAbstractEntity,
	#instVars : [
		'engine',
		'scene',
		'physicsWorld',
		'gameLogic',
		'defaultCameraNearDistance',
		'defaultCameraFarDistance',
		'defaultFogSettings',
		'defaultCameraCascadeSplitDistribution',
		'defaultCameraToneMappingOperator',
		'defaultCameraExposure',
		'defaultSoundGainFactor'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #'instance creation' }
WDESAbstractUniverse class >> for: anEngine [
	^ self basicNew initializeWithEngine: anEngine
]

{ #category : #sectors }
WDESAbstractUniverse >> activeSectors [
	"This method should return the set of active sectors"
	^ #()
]

{ #category : #physics }
WDESAbstractUniverse >> addEntitiesToPhysicsWorld [
	self activeSectors do: [ :sector |
		sector addedToPhysicsWorld: physicsWorld
	]
]

{ #category : #physics }
WDESAbstractUniverse >> addEntitiesToScene [
	self activeSectors do: [ :sector |
		sector addedToScene: scene
	]
]

{ #category : #'as yet unclassified' }
WDESAbstractUniverse >> buildSector: aBlock [
	| sector |
	sector := WDESSector new.
	self addChild: sector.
	aBlock value: sector.
	^ sector
]

{ #category : #model }
WDESAbstractUniverse >> createSimulationModel [
	self ensureValidEngine.
	^ (WDAESUniverseSimulationModel for: engine)
		universe: self;
		precacheResources;
		yourself
]

{ #category : #accessing }
WDESAbstractUniverse >> defaultCameraCascadeSplitDistribution [
	^ defaultCameraCascadeSplitDistribution
]

{ #category : #accessing }
WDESAbstractUniverse >> defaultCameraCascadeSplitDistribution: anObject [
	defaultCameraCascadeSplitDistribution := anObject
]

{ #category : #accessing }
WDESAbstractUniverse >> defaultCameraExposure [
	^ defaultCameraExposure
]

{ #category : #accessing }
WDESAbstractUniverse >> defaultCameraExposure: anObject [
	defaultCameraExposure := anObject
]

{ #category : #accessing }
WDESAbstractUniverse >> defaultCameraFarDistance [
	^ defaultCameraFarDistance
]

{ #category : #accessing }
WDESAbstractUniverse >> defaultCameraFarDistance: anObject [
	defaultCameraFarDistance := anObject
]

{ #category : #accessing }
WDESAbstractUniverse >> defaultCameraNearDistance [
	^ defaultCameraNearDistance
]

{ #category : #accessing }
WDESAbstractUniverse >> defaultCameraNearDistance: anObject [
	defaultCameraNearDistance := anObject
]

{ #category : #accessing }
WDESAbstractUniverse >> defaultCameraToneMappingOperator [
	^ defaultCameraToneMappingOperator
]

{ #category : #accessing }
WDESAbstractUniverse >> defaultCameraToneMappingOperator: anObject [
	defaultCameraToneMappingOperator := anObject
]

{ #category : #accessing }
WDESAbstractUniverse >> defaultFogSettings [
	^ defaultFogSettings
]

{ #category : #accessing }
WDESAbstractUniverse >> defaultFogSettings: fogSettings [
	defaultFogSettings := fogSettings
]

{ #category : #accessing }
WDESAbstractUniverse >> defaultSoundGainFactor [
	^ defaultSoundGainFactor
]

{ #category : #accessing }
WDESAbstractUniverse >> defaultSoundGainFactor: anObject [
	defaultSoundGainFactor := anObject
]

{ #category : #accesing }
WDESAbstractUniverse >> engine [
	^ engine
]

{ #category : #accesing }
WDESAbstractUniverse >> engine: anEngine [
	engine := anEngine.
	self engineChanged.
]

{ #category : #private }
WDESAbstractUniverse >> ensureValidEngine [
	engine ifNil: [ self engine: WDCEngine default ]
]

{ #category : #queries }
WDESAbstractUniverse >> findAnyEntityByTypeName: aTypeName [
	self typeName == aTypeName ifTrue: [ ^ self ].
	self activeSectors do: [ :child |
		(child findAnyEntityByTypeName: aTypeName) ifNotNil: [ :found | ^ found ]
	].

	^ nil
]

{ #category : #queries }
WDESAbstractUniverse >> findAnyPlayerStartPoint [
	^ (self findAnyEntityByTypeName: EntityTypeName_InfoPlayerStart)
]

{ #category : #accessing }
WDESAbstractUniverse >> gameLogic [
	^ gameLogic ifNil: [ gameLogic := WDAESGameLogic new universe: self ]
]

{ #category : #accessing }
WDESAbstractUniverse >> gameLogic: anObject [
	gameLogic := anObject
]

{ #category : #accessing }
WDESAbstractUniverse >> gameLogicClass: aClass [
	self gameLogic: (aClass new universe: self; yourself)
]

{ #category : #'as yet unclassified' }
WDESAbstractUniverse >> globalTransform [
	^ WMReversibleAffineTransformF identity
]

{ #category : #initialization }
WDESAbstractUniverse >> initialize [
	super initialize.
	defaultCameraNearDistance := 0.01.
	defaultCameraFarDistance := 1000.0.
	defaultCameraCascadeSplitDistribution := 0.5.
	defaultCameraToneMappingOperator := #linear.
	defaultCameraExposure := 1.0.
	defaultFogSettings := WDESFogSettings new.
	defaultSoundGainFactor := 1.0.
]

{ #category : #initialization }
WDESAbstractUniverse >> initializeWithEngine: anEngine [
	engine := anEngine.
	self initialize
]

{ #category : #accessing }
WDESAbstractUniverse >> physicsWorld [
	^ physicsWorld
]

{ #category : #accessing }
WDESAbstractUniverse >> physicsWorld: aPhysicsWorld [
	physicsWorld ifNotNil: [ self removeEntitiesFromPhysicsWorld ].
	physicsWorld := aPhysicsWorld.
	physicsWorld ifNotNil: [ self addEntitiesToPhysicsWorld ].
]

{ #category : #physics }
WDESAbstractUniverse >> removeEntitiesFromPhysicsWorld [
	self activeSectors do: [ :sector |
		sector removedFromPhysicsWorld: physicsWorld
	]
]

{ #category : #physics }
WDESAbstractUniverse >> removeEntitiesFromScene [
	self activeSectors do: [ :sector |
		sector removedFromScene: scene
	]
]

{ #category : #accessing }
WDESAbstractUniverse >> scene [
	^ scene
]

{ #category : #accessing }
WDESAbstractUniverse >> scene: anScene [
	scene ifNotNil: [ self removeEntitiesFromScene ].
	scene := anScene.
	scene ifNotNil: [ self addEntitiesToScene ].
	
]

{ #category : #simulation }
WDESAbstractUniverse >> tick: delta [
	physicsWorld ifNotNil: [ physicsWorld simulateTime: delta ].
	self activeSectors do: [ :sector | sector tick: delta ].
	self gameLogic tick: delta.
]

{ #category : #accessing }
WDESAbstractUniverse >> universe [
	^ self
]
