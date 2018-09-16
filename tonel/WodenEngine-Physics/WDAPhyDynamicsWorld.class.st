Class {
	#name : #WDAPhyDynamicsWorld,
	#superclass : #WDPhyDynamicsWorld,
	#instVars : [
		'physicsEngine',
		'handle',
		'rigidBodies',
		'onSimulation',
		'kinematicObjects'
	],
	#pools : [
		'APHYConstants'
	],
	#category : #'WodenEngine-Physics-AbstractPhysics'
}

{ #category : #adding }
WDAPhyDynamicsWorld >> addCharacterController: characterController [
	handle addCharacterController: (physicsEngine validateCharacterControllerHandle: characterController)
]

{ #category : #adding }
WDAPhyDynamicsWorld >> addGhostObject: ghostObject [
	handle addCollisionObject: (physicsEngine validateGhostObjectHandle: ghostObject) collision_filter_group: 1 collision_filter_mask: -1
]

{ #category : #adding }
WDAPhyDynamicsWorld >> addRigidBody: rigidBody [
	| rigidBodyHandle |
	rigidBodyHandle := physicsEngine validateRigidBodyHandle: rigidBody.
	handle addRigidBody: rigidBodyHandle first.
	rigidBody mass = 0.0 ifTrue: [
		kinematicObjects add: rigidBody.
	] ifFalse: [
		rigidBodies add: rigidBody.
	].
	
	rigidBody sceneNode ifNotNil: [
		rigidBody sceneNode onStateChangeDo: [ :body |
			onSimulation ifFalse: [ self updateRigidBodyFromSceneNode: rigidBody ]
		].
	
		self updateRigidBodyFromSceneNode: rigidBody
	].

]

{ #category : #'as yet unclassified' }
WDAPhyDynamicsWorld >> debugDrawOnDynamicMesh: meshBuilder [
	| bufferSize buffer |
	bufferSize := handle encodeDebugDrawing.
	bufferSize = 0 ifTrue: [ ^ self ].
	
	buffer := ByteArray new: bufferSize.
	handle getDebugDrawingData: bufferSize buffer: buffer.
	
	WDPhyDebugDrawingParser new
		meshBuilder: meshBuilder;
		parse: buffer
]

{ #category : #accessing }
WDAPhyDynamicsWorld >> gravity: gravity [
	handle setGravity: gravity x y: gravity y z: gravity z
]

{ #category : #accessing }
WDAPhyDynamicsWorld >> handle [
	^ handle
]

{ #category : #accessing }
WDAPhyDynamicsWorld >> handle: anObject [
	handle := anObject
]

{ #category : #initialization }
WDAPhyDynamicsWorld >> initialize [
	super initialize.
	rigidBodies := OrderedCollection new.
	kinematicObjects := OrderedCollection new.
	onSimulation := false.
]

{ #category : #accessing }
WDAPhyDynamicsWorld >> physicsEngine [
	^ physicsEngine
]

{ #category : #accessing }
WDAPhyDynamicsWorld >> physicsEngine: anObject [
	physicsEngine := anObject
]

{ #category : #adding }
WDAPhyDynamicsWorld >> removeRigidBody: rigidBody [
	rigidBody handle ifNotNil: [ handle removeRigidBody: rigidBody handle first ]

]

{ #category : #rendering }
WDAPhyDynamicsWorld >> simulateTime: delta [
	onSimulation := true.
	[
		handle stepSimulation: delta max_sub_steps: 2 fixed_time_step: 1.0/120.0.
		rigidBodies do: [ :body | self updateSceneNodeFromRigidBody: body ]
	] ensure: [ onSimulation := false ]
]

{ #category : #rendering }
WDAPhyDynamicsWorld >> updateRigidBodyFromSceneNode: rigidBody [
	| transform |
	rigidBody sceneNode ifNil: [ ^ self ].
	
	transform := physicsEngine convertWMTransform: rigidBody sceneNode transform.
	rigidBody handle first setTransformFrom: transform.
	rigidBody handle second setTransformFrom: transform.
]

{ #category : #rendering }
WDAPhyDynamicsWorld >> updateSceneNodeFromRigidBody: rigidBody [
	| motionState rawTransform |
	rigidBody sceneNode ifNil: [ ^ self ].
	
	motionState := rigidBody handle second.
	rawTransform := APHYTransform new.
	motionState getTransformInto: rawTransform.
	rigidBody sceneNode
		transform: (physicsEngine convertTransform: rawTransform)
]
