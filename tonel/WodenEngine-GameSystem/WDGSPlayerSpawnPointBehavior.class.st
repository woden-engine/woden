Class {
	#name : #WDGSPlayerSpawnPointBehavior,
	#superclass : #WDGSBehavior,
	#category : #'WodenEngine-GameSystem-Player'
}

{ #category : #'map events' }
WDGSPlayerSpawnPointBehavior >> spawn [
	self levelPlayer spawnPlayerAtPosition: entity position.
]
