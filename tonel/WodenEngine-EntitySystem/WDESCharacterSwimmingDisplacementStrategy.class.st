Class {
	#name : #WDESCharacterSwimmingDisplacementStrategy,
	#superclass : #WDESAnimalCharacterDisplacementStrategy,
	#category : #'WodenEngine-EntitySystem-Behaviors'
}

{ #category : #accessing }
WDESCharacterSwimmingDisplacementStrategy >> buoyancy [
	^ 8.8
]

{ #category : #accessing }
WDESCharacterSwimmingDisplacementStrategy >> character: aCharacter [
	super character: aCharacter.
	
	aCharacter linearVelocity: aCharacter linearVelocity*0.1
]

{ #category : #testing }
WDESCharacterSwimmingDisplacementStrategy >> isUnderwaterDisplacementStrategy [
	^ true
]
