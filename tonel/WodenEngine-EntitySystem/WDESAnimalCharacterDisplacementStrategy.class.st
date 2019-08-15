Class {
	#name : #WDESAnimalCharacterDisplacementStrategy,
	#superclass : #WDESCharacterDisplacementStrategy,
	#category : #'WodenEngine-EntitySystem-Behaviors'
}

{ #category : #actions }
WDESAnimalCharacterDisplacementStrategy >> jump [
	^ character physicsCharacterController jump
]

{ #category : #simulation }
WDESAnimalCharacterDisplacementStrategy >> prePhysicsTick: delta [
	| movementDirection |
	movementDirection := character leftStickDirection.
	
	character linearAcceleration: (WMVector3F x: movementDirection x y: 0.0 z: movementDirection y negated) normalized.
	
	character isUnderwater ifTrue: [
		self isUnderwaterDisplacementStrategy ifFalse: [ 
			^ character useSwimmingDisplacementStrategy
				prePhysicsTick: delta
		]
	] ifFalse: [ 
		self isUnderwaterDisplacementStrategy ifTrue: [ 
			^ character useWalkingDisplacementStrategy
				prePhysicsTick: delta
		]
	].

	super prePhysicsTick: delta.
	self
		adjustHeadAndBodyOrientations;
		tickLinearMovement: delta
]

{ #category : #simulation }
WDESAnimalCharacterDisplacementStrategy >> speedMultiplier [
	^ character running ifTrue: [ 4.0 ] ifFalse: [ 2.0 ].
]

{ #category : #simulation }
WDESAnimalCharacterDisplacementStrategy >> tickLinearMovement: delta [

	| accel |
	accel := (character bodyOrientation transformVector3: character linearAcceleration*character linearViscosity * self speedMultiplier).
	accel := accel - (character linearVelocity * character linearViscosity).
	
	character linearVelocity: character linearVelocity + (accel*delta).
]
