Trait {
	#name : #TWDESRayCastingVolume,
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #'ray casting' }
TWDESRayCastingVolume >> rayCast: ray [
	self explicitRequirement
]

{ #category : #'as yet unclassified' }
TWDESRayCastingVolume >> volumeOwnerComponent [
	self explicitRequirement
]

{ #category : #'as yet unclassified' }
TWDESRayCastingVolume >> volumeOwnerEntity [
	self explicitRequirement
]
