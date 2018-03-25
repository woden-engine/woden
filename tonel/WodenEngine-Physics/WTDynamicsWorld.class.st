Class {
	#name : #WTDynamicsWorld,
	#superclass : #Object,
	#category : 'WodenEngine-Physics-Interface'
}

{ #category : #adding }
WTDynamicsWorld >> addRigidBodies: rigidBodies [
	rigidBodies do: [ :body | self addRigidBody: body ]
]

{ #category : #adding }
WTDynamicsWorld >> addRigidBody: rigidBody [
	self subclassResponsibility
]

{ #category : #accessing }
WTDynamicsWorld >> gravity: aWMVector3 [
	self subclassResponsibility
]

{ #category : #rendering }
WTDynamicsWorld >> simulateTime: delta [
	self subclassResponsibility
]
