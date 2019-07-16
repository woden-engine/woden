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
	self validCollisionObject
		addToPhysicsWorld: physicsWorld;
		sceneNode: ownerEntity.
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
	ownerEntity isVolumeSensorEntity ifTrue: [
		collisionObject := WDPhyGhostObject new
			shape: collisionShape;
			makeSensorTriggerCollisionObject;
			yourself.
	] ifFalse: [ 
		collisionObject := WDPhyRigidBody new
			mass: 0.0;
			shape: collisionShape;
			makeStaticCollisionObject;
			yourself.
	]
]

{ #category : #notifications }
WDESStaticCollisionObject >> removedFromPhysicsWorld: physicsWorld [
	collisionObject ifNotNil: [ 
		collisionObject removeFromPhysicsWorld: physicsWorld
	].

]

{ #category : #notifications }
WDESStaticCollisionObject >> validCollisionObject [
	collisionObject ifNil: [ self createCollisionObject ].
	^ collisionObject
]
