Class {
	#name : #WDGSBehavior,
	#superclass : #WDGSComponent,
	#classVars : [
		'Box3D',
		'Complex',
		'Quaternion',
		'ReversibleAffineTransform',
		'Vector2',
		'Vector3',
		'Vector4'
	],
	#category : #'WodenEngine-OldGameSystem-Level'
}

{ #category : #'class initialization' }
WDGSBehavior class >> initialize [
		
	Vector2 := Float64x2.
	Vector3 := Float64x3.
	Vector4 := Float64x4.
	Complex := ComplexF64.
	Quaternion := QuaternionF64.

	ReversibleAffineTransform := ReversibleAffineTransform3dF64.
	
	Box3D := BoxF64.

]

{ #category : #adding }
WDGSBehavior >> addedToEntity: anEntity [
	super addedToEntity: anEntity.
	anEntity physicsComponent ifNotNil: [ :physics |self setupPhysicsComponent: physics ]
]

{ #category : #accessing }
WDGSBehavior >> bucket [
	^ #behavior
]

{ #category : #'resource loading' }
WDGSBehavior >> loadMesh: modelName [
	^ self engine resourceCache loadMesh: modelName
]

{ #category : #utility }
WDGSBehavior >> localBoundingBox [
	^ entity spatialDescription localBoundingBox
]

{ #category : #utility }
WDGSBehavior >> setBoundingBox: aBox [
	entity spatialDescription localBoundingBox: aBox asBoxF64
]

{ #category : #utility }
WDGSBehavior >> setMeshNamed: meshName [
	| mesh |
	mesh := self loadMesh: meshName.
	entity ensureSpatialObject node renderable: mesh.
	^ mesh
]

{ #category : #physics }
WDGSBehavior >> setupPhysicsComponent: aPhysicsComponent [
]

{ #category : #behaviors }
WDGSBehavior >> subscribeToTouchEvents [
	entity subscribeToTouchEvents
]

{ #category : #events }
WDGSBehavior >> touch: anEntity [
]
