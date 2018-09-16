Class {
	#name : #WDPhyCollisionObject,
	#superclass : #WDPhyObject,
	#instVars : [
		'shape',
		'position'
	],
	#category : #'WodenEngine-Physics-Interface'
}

{ #category : #accessing }
WDPhyCollisionObject >> applyTransformInHandle [
	physicsEngine ifNotNil: [ physicsEngine setCollisionObject: self position: position ]
]

{ #category : #accessing }
WDPhyCollisionObject >> hasValidHandle [
	^ handle ~~ nil and: [ handle isValid ]
]

{ #category : #initialization }
WDPhyCollisionObject >> initialize [
	super initialize.
	position := WMVector3F zero.
]

{ #category : #testing }
WDPhyCollisionObject >> isGhostObject [
	^ false
]

{ #category : #testing }
WDPhyCollisionObject >> isGhostObjectWithPairCache [
	^ false
]

{ #category : #testing }
WDPhyCollisionObject >> isRigidBody [
	^ false
]

{ #category : #accessing }
WDPhyCollisionObject >> position [
	^ physicsEngine ifNotNil: [ physicsEngine getCollisionObjectPosition: self ] ifNil: [ position ]
]

{ #category : #accessing }
WDPhyCollisionObject >> position: aPosition [
	position := aPosition.
	self applyTransformInHandle
]

{ #category : #accessing }
WDPhyCollisionObject >> shape [
	
	^ shape
]

{ #category : #accessing }
WDPhyCollisionObject >> shape: anObject [
	
	shape := anObject
]
