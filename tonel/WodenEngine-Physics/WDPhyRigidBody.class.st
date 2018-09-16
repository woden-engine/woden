Class {
	#name : #WDPhyRigidBody,
	#superclass : #WDPhyCollisionObject,
	#instVars : [
		'sceneNode',
		'mass'
	],
	#category : #'WodenEngine-Physics-Interface'
}

{ #category : #accessing }
WDPhyRigidBody >> initialize [
	mass := 0.0.
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
WDPhyRigidBody >> removeFromWorld: world [
	^ world removeRigidBody: self
]

{ #category : #accessing }
WDPhyRigidBody >> sceneNode [
	^ sceneNode
]

{ #category : #accessing }
WDPhyRigidBody >> sceneNode: anObject [
	sceneNode := anObject
]

{ #category : #accessing }
WDPhyRigidBody >> update: delta forNode: sceneNode [
	self hasValidHandle ifTrue: [ handle updateMotionStateTo: sceneNode ]
]
