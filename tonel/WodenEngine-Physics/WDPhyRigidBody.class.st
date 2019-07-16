Class {
	#name : #WDPhyRigidBody,
	#superclass : #WDPhyCollisionObject,
	#instVars : [
		'mass'
	],
	#category : #'WodenEngine-Physics-Interface'
}

{ #category : #removing }
WDPhyRigidBody >> addToPhysicsWorld: physicsWorld [
	physicsWorld addRigidBody: self
]

{ #category : #accessing }
WDPhyRigidBody >> initialize [
	super initialize.
	mass := 0.0.
	self useDefaultCollisionGroup.
]

{ #category : #'as yet unclassified' }
WDPhyRigidBody >> isRigidBody [
	^ true
]

{ #category : #accessing }
WDPhyRigidBody >> mass [
	
	^ mass
]

{ #category : #accessing }
WDPhyRigidBody >> mass: anObject [
	
	mass := anObject
]

{ #category : #removing }
WDPhyRigidBody >> removeFromPhysicsWorld: physicsWorld [
	physicsWorld removeRigidBody: self
]

{ #category : #removing }
WDPhyRigidBody >> removeFromWorld: world [
	^ world removeRigidBody: self
]

{ #category : #accessing }
WDPhyRigidBody >> update: delta forNode: sceneNode [
	self hasValidHandle ifTrue: [ handle updateMotionStateTo: sceneNode ]
]
