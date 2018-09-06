Trait {
	#name : #TWDGSLevelPlayer,
	#category : #'WodenEngine-GameSystem-LevelPlayer'
}

{ #category : #adding }
TWDGSLevelPlayer >> addPlayerSpawnPosition: aPosition [
]

{ #category : #accessing }
TWDGSLevelPlayer >> camera [
	^ self explicitRequirement
]

{ #category : #accessing }
TWDGSLevelPlayer >> camera: aCamera [
	^ self explicitRequirement
]

{ #category : #accessing }
TWDGSLevelPlayer >> map [
	^ self explicitRequirement
]

{ #category : #accessing }
TWDGSLevelPlayer >> map: aMap [
	^ self explicitRequirement
]

{ #category : #accessing }
TWDGSLevelPlayer >> playerEventHandler [
	^ self explicitRequirement
]

{ #category : #accessing }
TWDGSLevelPlayer >> playerEventHandler: playerEventHandler [
	^ self explicitRequirement
]

{ #category : #'map events' }
TWDGSLevelPlayer >> spawn [
	self map spawn
]
