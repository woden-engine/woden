Class {
	#name : #WDESAnimalCharacterDisplacementStrategy,
	#superclass : #WDESCharacterDisplacementStrategy,
	#category : #'WodenEngine-EntitySystem-Behaviors'
}

{ #category : #simulation }
WDESAnimalCharacterDisplacementStrategy >> accelerationMagnitude [
	^ self movementSpeed * character linearDamping
]

{ #category : #actions }
WDESAnimalCharacterDisplacementStrategy >> jump [
	^ character physicsCharacterController jump
]

{ #category : #simulation }
WDESAnimalCharacterDisplacementStrategy >> movementAxes [
	^ Float32x3 ones
]

{ #category : #simulation }
WDESAnimalCharacterDisplacementStrategy >> movementSpeed [
	^ character running ifTrue: [ 6.0 ] ifFalse: [ 2.0 ]
]

{ #category : #simulation }
WDESAnimalCharacterDisplacementStrategy >> prePhysicsTick: delta [
	| movementDirection |
	movementDirection := character leftStickDirection.
	character
		linearAcceleration: (Float32x3 x: movementDirection x y: movementDirection z z: movementDirection y negated) normalized * self movementAxes * self accelerationMagnitude.
	
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
WDESAnimalCharacterDisplacementStrategy >> terminalSpeed [
	^ 1.4 * self speedMultiplier
]

{ #category : #simulation }
WDESAnimalCharacterDisplacementStrategy >> tickLinearMovement: delta [

	| accel |
	accel := (character bodyOrientation transformVector3: character linearAcceleration).
	accel := accel - (character linearVelocity * character linearDamping).
	
	character linearVelocity: character linearVelocity + (accel*delta).
]
