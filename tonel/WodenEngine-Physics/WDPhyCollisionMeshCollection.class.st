Class {
	#name : #WDPhyCollisionMeshCollection,
	#superclass : #WDPhyObject,
	#instVars : [
		'collisionMeshes'
	],
	#category : #'WodenEngine-Physics-Interface'
}

{ #category : #adding }
WDPhyCollisionMeshCollection >> addAll: meshes [
	collisionMeshes addAll: meshes.
	handle ifNotNil: [
		meshes do: [ :mesh |
			physicsEngine collisionMesh: mesh addedToCollection: self
		]
	]
]

{ #category : #adding }
WDPhyCollisionMeshCollection >> addMeshesFromSceneNode: sceneNode [
	self addAll: sceneNode renderable createCollisionTriangleMeshAccessors.
	sceneNode childrenDo: [ :childNode |
		self addMeshesFromSceneNode: childNode withTransform: childNode transform
	]
]

{ #category : #adding }
WDPhyCollisionMeshCollection >> addMeshesFromSceneNode: sceneNode withTransform: meshTransform [
	self addAll: (sceneNode renderable createCollisionTriangleMeshAccessors
		collect: [:meshAccessor |
			meshAccessor copy transform: meshTransform
		]).
	sceneNode childrenDo: [ :childNode |
		self addMeshesFromSceneNode: childNode withTransform: (meshTransform transformTransform: childNode transform)
	]
]

{ #category : #'as yet unclassified' }
WDPhyCollisionMeshCollection >> collisionMeshes [
	^ collisionMeshes
]

{ #category : #initialization }
WDPhyCollisionMeshCollection >> initialize [
	super initialize.
	collisionMeshes := OrderedCollection new.
	
]
