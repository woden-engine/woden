Class {
	#name : #WDAGSLevelModel,
	#superclass : #WDASceneModel,
	#instVars : [
		'map',
		'playerEventHandler'
	],
	#category : 'WodenEngine-GameSystem-LevelPlayer'
}

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

{ #category : #accessing }
WDAGSLevelModel >> playerEventHandler [
	^ playerEventHandler
]

{ #category : #accessing }
WDAGSLevelModel >> playerEventHandler: anObject [
	playerEventHandler := anObject
]

{ #category : #'map events' }
WDAGSLevelModel >> spawn [
	self map spawn
]

{ #category : #'as yet unclassified' }
WDAGSLevelModel >> spawnPlayerAtPosition: aPosition [
	self flag: 'TODO: Try to move this part into the view.'.
	map spawnEntityWithBehavior: WDGSPlayerBehavior new position: aPosition.
]
