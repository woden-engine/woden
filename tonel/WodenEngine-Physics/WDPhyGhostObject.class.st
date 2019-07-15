Class {
	#name : #WDPhyGhostObject,
	#superclass : #WDPhyCollisionObject,
	#category : #'WodenEngine-Physics-Interface'
}

{ #category : #removing }
WDPhyGhostObject >> addToPhysicsWorld: physicsWorld [
	physicsWorld addGhostObject: self
]

{ #category : #testing }
WDPhyGhostObject >> isGhostObject [
	^ true
]

{ #category : #removing }
WDPhyGhostObject >> removeFromPhysicsWorld: physicsWorld [
	physicsWorld removeGhostObject: self
]
