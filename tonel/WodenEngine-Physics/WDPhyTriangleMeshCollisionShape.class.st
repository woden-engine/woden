Class {
	#name : #WDPhyTriangleMeshCollisionShape,
	#superclass : #WDPhyCollisionShape,
	#instVars : [
		'collisionMeshCollection'
	],
	#category : #'WodenEngine-Physics-Interface'
}

{ #category : #'as yet unclassified' }
WDPhyTriangleMeshCollisionShape >> accept: aVisitor [
	^ aVisitor visitTriangleMeshShape: self
]

{ #category : #accessing }
WDPhyTriangleMeshCollisionShape >> collisionMeshCollection [
	^ collisionMeshCollection
]

{ #category : #accessing }
WDPhyTriangleMeshCollisionShape >> collisionMeshCollection: anObject [
	collisionMeshCollection := anObject
]
