Class {
	#name : #WDGSPlayerSpawnPointBehavior,
	#superclass : #WDGSBehavior,
	#category : #'WodenEngine-GameSystem-Player'
}

{ #category : #'map events' }
WDGSPlayerSpawnPointBehavior >> spawn [
	self levelPlayer addPlayerSpawnPosition: entity position.
]
