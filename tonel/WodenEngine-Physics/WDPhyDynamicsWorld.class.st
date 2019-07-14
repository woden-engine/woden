Class {
	#name : #WDPhyDynamicsWorld,
	#superclass : #Object,
	#category : #'WodenEngine-Physics-Interface'
}

{ #category : #adding }
WDPhyDynamicsWorld >> addCharacterController: ghostObject [
	self subclassResponsibility
]

{ #category : #adding }
WDPhyDynamicsWorld >> addGhostObject: ghostObject [
	self subclassResponsibility
]

{ #category : #adding }
WDPhyDynamicsWorld >> addRigidBodies: rigidBodies [
	rigidBodies do: [ :body | self addRigidBody: body ]
]

{ #category : #adding }
WDPhyDynamicsWorld >> addRigidBody: rigidBody [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDPhyDynamicsWorld >> debugDrawOnDynamicMesh: meshBuilder [
]

{ #category : #accessing }
WDPhyDynamicsWorld >> gravity: aWMVector3 [
	self subclassResponsibility
]

{ #category : #adding }
WDPhyDynamicsWorld >> removeCharacterController: ghostObject [
	self subclassResponsibility
]

{ #category : #adding }
WDPhyDynamicsWorld >> removeGhostObject: ghostObject [
	self subclassResponsibility
]

{ #category : #adding }
WDPhyDynamicsWorld >> removeRigidBody: rigidBody [
	self subclassResponsibility
]

{ #category : #rendering }
WDPhyDynamicsWorld >> simulateTime: delta [
	self subclassResponsibility
]
