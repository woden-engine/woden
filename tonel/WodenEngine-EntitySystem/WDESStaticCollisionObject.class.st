Class {
	#name : #WDESStaticCollisionObject,
	#superclass : #WDESAbstractCollisionShapeComponent,
	#instVars : [
		'collisionObject',
		'collisionShape'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #notifications }
WDESStaticCollisionObject >> addedToPhysicsWorld: physicsWorld [
	physicsWorld addRigidBody: self validCollisionObject.
	self validCollisionObject sceneNode: ownerEntity.
]

{ #category : #accessing }
WDESStaticCollisionObject >> collisionObject [
	^ collisionObject
]

{ #category : #accessing }
WDESStaticCollisionObject >> collisionObject: anObject [
	collisionObject := anObject
]

{ #category : #accessing }
WDESStaticCollisionObject >> collisionShape [
	^ collisionShape
]

{ #category : #accessing }
WDESStaticCollisionObject >> collisionShape: anObject [
	collisionShape := anObject
]

{ #category : #notifications }
WDESStaticCollisionObject >> createCollisionObject [
	collisionObject := WDPhyRigidBody new
		mass: 0.0;
		shape: collisionShape;
		yourself.
]

{ #category : #notifications }
WDESStaticCollisionObject >> removedFromPhysicsWorld: physicsWorld [
	collisionObject ifNotNil: [ 
		physicsWorld removeRigidBody: collisionObject
	].

]

{ #category : #notifications }
WDESStaticCollisionObject >> validCollisionObject [
	collisionObject ifNil: [ self createCollisionObject ].
	^ collisionObject
]
