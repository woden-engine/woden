Class {
	#name : #WDESCharacterDisplacementStrategy,
	#superclass : #Object,
	#instVars : [
		'character'
	],
	#category : #'WodenEngine-EntitySystem-Behaviors'
}

{ #category : #'instance creation' }
WDESCharacterDisplacementStrategy class >> for: aCharacter [
	^ self new character: aCharacter
]

{ #category : #'as yet unclassified' }
WDESCharacterDisplacementStrategy >> activateUseCommand [
	^ character activateUseActuator
]

{ #category : #accessing }
WDESCharacterDisplacementStrategy >> buoyancy [
	^ 0
]

{ #category : #accessing }
WDESCharacterDisplacementStrategy >> character [
	^ character
]

{ #category : #accessing }
WDESCharacterDisplacementStrategy >> character: anObject [
	character := anObject
]

{ #category : #testing }
WDESCharacterDisplacementStrategy >> isUnderwaterDisplacementStrategy [
	^ false
]

{ #category : #actions }
WDESCharacterDisplacementStrategy >> jump [
	"Jump action"
]

{ #category : #simulation }
WDESCharacterDisplacementStrategy >> postPhysicsTick: delta [
	self usingPhysicsObject ifTrue: [ 
		character ownerEntity transform: (WMReversibleAffineTransformF identity
			orthonormal: character bodyOrientation translation: character ghostObject position).
	]

]

{ #category : #simulation }
WDESCharacterDisplacementStrategy >> prePhysicsTick: delta [
]

{ #category : #simulation }
WDESCharacterDisplacementStrategy >> tick: delta [
]

{ #category : #hooks }
WDESCharacterDisplacementStrategy >> usingPhysicsObject [
	^ true
]
