Class {
	#name : #WDGSPlayerSpawnPointBehavior,
	#superclass : #WDGSBehavior,
	#category : #'WodenEngine-OldGameSystem-Player'
}

{ #category : #'map events' }
WDGSPlayerSpawnPointBehavior >> spawn [
	self levelPlayer addPlayerSpawnPosition: entity position.
]
