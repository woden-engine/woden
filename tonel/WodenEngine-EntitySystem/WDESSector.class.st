Class {
	#name : #WDESSector,
	#superclass : #WDESGenericEntity,
	#instVars : [
		'tickingEntities'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #building }
WDESSector class >> build: aBlock [
	| result |
	result := self new.
	aBlock value: self.
	^ result
]

{ #category : #adding }
WDESSector >> addEntity: anEntity toSpawnPoint: spawnPointEntity [
	spawnPointEntity ifNil: [ 
		self addChild: anEntity
	] ifNotNil: [
		spawnPointEntity sector addChild: anEntity.
		anEntity transform: spawnPointEntity sectorTransform
	]
]

{ #category : #simulation }
WDESSector >> addTickingEntity: anEntity [
	tickingEntities add: anEntity
]

{ #category : #scene }
WDESSector >> addedToScene: anScene [
	sceneNode ifNotNil: [ sceneNode removeFromScene ].
	anScene add: self validSceneNode.
	super addedToScene: anScene.
	
]

{ #category : #initialization }
WDESSector >> initialize [
	super initialize.
	tickingEntities := IdentitySet new.
]

{ #category : #simulation }
WDESSector >> removeTickingEntity: anEntity [
	tickingEntities remove: anEntity
]

{ #category : #scene }
WDESSector >> removedFromScene: anScene [
	super removedFromScene: anScene.
	sceneNode ifNotNil: [ anScene remove: sceneNode ].
]

{ #category : #accessing }
WDESSector >> sceneNode: newSceneNode [
	sceneNode := newSceneNode
]

{ #category : #accessing }
WDESSector >> sector [
	^ self
]

{ #category : #'as yet unclassified' }
WDESSector >> sectorTransform [
	^ WMReversibleAffineTransformF identity
]

{ #category : #simulation }
WDESSector >> tick: delta [
	super tick: delta.
	tickingEntities do: [ :entity | entity tick: delta ]
]
