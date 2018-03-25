Class {
	#name : #WTGSPlayerSpawnPointBehavior,
	#superclass : #WTGSBehavior,
	#category : 'WodenEngine-GameSystem-Player'
}

{ #category : #'map events' }
WTGSPlayerSpawnPointBehavior >> spawn [
	self levelPlayer spawnPlayerAtPosition: entity position.
]
