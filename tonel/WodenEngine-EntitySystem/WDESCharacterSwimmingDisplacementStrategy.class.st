Class {
	#name : #WDESCharacterSwimmingDisplacementStrategy,
	#superclass : #WDESAnimalCharacterDisplacementStrategy,
	#category : #'WodenEngine-EntitySystem-Behaviors'
}

{ #category : #accessing }
WDESCharacterSwimmingDisplacementStrategy >> buoyancy [
	^ 8.8
]

{ #category : #testing }
WDESCharacterSwimmingDisplacementStrategy >> isUnderwaterDisplacementStrategy [
	^ true
]
