Trait {
	#name : #TWTGSLevelPlayer,
	#category : 'WodenEngine-GameSystem-LevelPlayer'
}

{ #category : #accessing }
TWTGSLevelPlayer >> camera [
	^ self explicitRequirement
]

{ #category : #accessing }
TWTGSLevelPlayer >> camera: aCamera [
	^ self explicitRequirement
]

{ #category : #accessing }
TWTGSLevelPlayer >> map [
	^ self explicitRequirement
]

{ #category : #accessing }
TWTGSLevelPlayer >> map: aMap [
	^ self explicitRequirement
]

{ #category : #accessing }
TWTGSLevelPlayer >> playerEventHandler [
	^ self explicitRequirement
]

{ #category : #accessing }
TWTGSLevelPlayer >> playerEventHandler: playerEventHandler [
	^ self explicitRequirement
]

{ #category : #'map events' }
TWTGSLevelPlayer >> spawn [
	self map spawn
]
