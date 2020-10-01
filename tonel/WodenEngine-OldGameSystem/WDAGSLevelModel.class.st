Class {
	#name : #WDAGSLevelModel,
	#superclass : #WDASceneModel,
	#instVars : [
		'map',
		'playerEventHandler',
		'playerSpawnPositions'
	],
	#category : #'WodenEngine-OldGameSystem-LevelPlayer'
}

{ #category : #'as yet unclassified' }
WDAGSLevelModel class >> loadJsonFromFileNamed: aFileName [
	^ self new loadJsonFromFileNamed: aFileName
]

{ #category : #adding }
WDAGSLevelModel >> addPlayerSpawnPosition: aPosition [
	playerSpawnPositions add: aPosition
]

{ #category : #'as yet unclassified' }
WDAGSLevelModel >> createPlayer [
	^ self createPlayerAtPosition: self selectPlayerSpawnPosition
]

{ #category : #'as yet unclassified' }
WDAGSLevelModel >> createPlayerAtPosition: aPosition [
	^ map createEntityWithBehavior: WDGSPlayerBehavior new position: aPosition.
]

{ #category : #'as yet unclassified' }
WDAGSLevelModel >> defaultViewClass [
	^ WDAGSLevelPlayerView
]

{ #category : #initialization }
WDAGSLevelModel >> initializeModel [
	super initializeModel.
	playerSpawnPositions := OrderedCollection new.
]

{ #category : #'as yet unclassified' }
WDAGSLevelModel >> loadJsonFromFileNamed: aFileName [
	self map: (WDGSMap loadJsonFromFileNamed: aFileName)
]

{ #category : #accessing }
WDAGSLevelModel >> map [
	^ map
]

{ #category : #accessing }
WDAGSLevelModel >> map: anObject [
	scene ifNil: [ self newScene ].
	map ifNotNil: [
		map scene: nil; levelPlayer: nil
	].

	map := anObject.
	
	map ifNotNil: [
		map scene: scene; levelPlayer: self
	]
	
]

{ #category : #'as yet unclassified' }
WDAGSLevelModel >> selectPlayerSpawnPosition [
	^ playerSpawnPositions
		ifEmpty: [ Float64x3 zero ]
		ifNotEmpty: [ playerSpawnPositions first ]
]

{ #category : #'map events' }
WDAGSLevelModel >> spawn [
	self map spawn
]

{ #category : #'rendering process stages' }
WDAGSLevelModel >> updateForFrameDelta: delta [
	super updateForFrameDelta: delta.
	map simulateTime: delta
]
