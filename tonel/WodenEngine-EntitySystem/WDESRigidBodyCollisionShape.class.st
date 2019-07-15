Class {
	#name : #WDESRigidBodyCollisionShape,
	#superclass : #WDESAbstractCollisionShapeComponent,
	#instVars : [
		'collisionShape'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #notifications }
WDESRigidBodyCollisionShape >> addedToPhysicsWorld: physicsWorld [
	ownerEntity applyCollisionShapeToRigidBody: self
]

{ #category : #accessing }
WDESRigidBodyCollisionShape >> collisionShape [
	^ collisionShape
]

{ #category : #accessing }
WDESRigidBodyCollisionShape >> collisionShape: anObject [
	collisionShape := anObject
]
