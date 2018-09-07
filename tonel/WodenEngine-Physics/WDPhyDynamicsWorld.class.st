Class {
	#name : #WDPhyDynamicsWorld,
	#superclass : #Object,
	#category : #'WodenEngine-Physics-Interface'
}

{ #category : #adding }
WDPhyDynamicsWorld >> addRigidBodies: rigidBodies [
	rigidBodies do: [ :body | self addRigidBody: body ]
]

{ #category : #adding }
WDPhyDynamicsWorld >> addRigidBody: rigidBody [
	self subclassResponsibility
]

{ #category : #accessing }
WDPhyDynamicsWorld >> gravity: aWMVector3 [
	self subclassResponsibility
]

{ #category : #rendering }
WDPhyDynamicsWorld >> simulateTime: delta [
	self subclassResponsibility
]
