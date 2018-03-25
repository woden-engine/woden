Class {
	#name : #WTRigidBody,
	#superclass : #Object,
	#instVars : [
		'sceneNode',
		'mass',
		'shape',
		'handle'
	],
	#category : 'WodenEngine-Physics-Interface'
}

{ #category : #accessing }
WTRigidBody >> handle [
	^ handle
]

{ #category : #accessing }
WTRigidBody >> handle: anObject [
	handle := anObject
]

{ #category : #accessing }
WTRigidBody >> hasValidHandle [
	^ handle ~~ nil and: [ handle isValid ]
]

{ #category : #accessing }
WTRigidBody >> initialize [
	mass := 0.0.
]

{ #category : #'as yet unclassified' }
WTRigidBody >> isRigidBody [
	^ true
]

{ #category : #accessing }
WTRigidBody >> mass [
	
	^ mass
]

{ #category : #accessing }
WTRigidBody >> mass: anObject [
	
	mass := anObject
]

{ #category : #accessing }
WTRigidBody >> sceneNode [
	^ sceneNode
]

{ #category : #accessing }
WTRigidBody >> sceneNode: anObject [
	sceneNode := anObject
]

{ #category : #accessing }
WTRigidBody >> shape [
	
	^ shape
]

{ #category : #accessing }
WTRigidBody >> shape: anObject [
	
	shape := anObject
]

{ #category : #accessing }
WTRigidBody >> update: delta forNode: sceneNode [
	self hasValidHandle ifTrue: [ handle updateMotionStateTo: sceneNode ]
]
