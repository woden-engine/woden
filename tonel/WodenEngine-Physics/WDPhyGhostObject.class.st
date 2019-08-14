Class {
	#name : #WDPhyGhostObject,
	#superclass : #WDPhyCollisionObject,
	#category : #'WodenEngine-Physics-Interface'
}

{ #category : #removing }
WDPhyGhostObject >> addToPhysicsWorld: physicsWorld [
	self assert: ownerPhysicsWorld isNil.
	physicsWorld addGhostObject: self.
	ownerPhysicsWorld := physicsWorld
]

{ #category : #testing }
WDPhyGhostObject >> isGhostObject [
	^ true
]

{ #category : #removing }
WDPhyGhostObject >> removeFromPhysicsWorld: physicsWorld [
	physicsWorld removeGhostObject: self
]
