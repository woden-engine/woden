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
	linearVelocity := WMVector3F zero.
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
	(linearVelocity closeTo: WMVector3F zero) ifTrue: [ ^ self ].

	self ownerEntity translateBy: (linearVelocity * delta).

]
