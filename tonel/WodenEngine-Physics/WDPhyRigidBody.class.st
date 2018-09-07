Class {
	#name : #WDPhyRigidBody,
	#superclass : #Object,
	#instVars : [
		'sceneNode',
		'mass',
		'shape',
		'handle'
	],
	#category : #'WodenEngine-Physics-Interface'
}

{ #category : #accessing }
WDPhyRigidBody >> handle [
	^ handle
]

{ #category : #accessing }
WDPhyRigidBody >> handle: anObject [
	handle := anObject
]

{ #category : #accessing }
WDPhyRigidBody >> hasValidHandle [
	^ handle ~~ nil and: [ handle isValid ]
]

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

{ #category : #accessing }
WDPhyRigidBody >> sceneNode [
	^ sceneNode
]

{ #category : #accessing }
WDPhyRigidBody >> sceneNode: anObject [
	sceneNode := anObject
]

{ #category : #accessing }
WDPhyRigidBody >> shape [
	
	^ shape
]

{ #category : #accessing }
WDPhyRigidBody >> shape: anObject [
	
	shape := anObject
]

{ #category : #accessing }
WDPhyRigidBody >> update: delta forNode: sceneNode [
	self hasValidHandle ifTrue: [ handle updateMotionStateTo: sceneNode ]
]
