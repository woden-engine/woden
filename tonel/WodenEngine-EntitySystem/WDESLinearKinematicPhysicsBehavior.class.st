Class {
	#name : #WDESLinearKinematicPhysicsBehavior,
	#superclass : #WDESKinematicPhysicsBehavior,
	#instVars : [
		'linearVelocity'
	],
	#category : #'WodenEngine-EntitySystem-Behaviors'
}

{ #category : #initialization }
WDESLinearKinematicPhysicsBehavior >> initialize [
	super initialize.
	linearVelocity := Float32x3 zeros.
]

{ #category : #accessing }
WDESLinearKinematicPhysicsBehavior >> linearVelocity [
	^ linearVelocity
]

{ #category : #accessing }
WDESLinearKinematicPhysicsBehavior >> linearVelocity: anObject [
	linearVelocity := anObject
]

{ #category : #simulation }
WDESLinearKinematicPhysicsBehavior >> prePhysicsTick: delta [
	(linearVelocity closeTo: Float32x3 zeros) ifTrue: [ ^ self ].

	self ownerEntity translateBy: (linearVelocity * delta).

]
