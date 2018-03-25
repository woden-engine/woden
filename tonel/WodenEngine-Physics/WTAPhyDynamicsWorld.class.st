Class {
	#name : #WTAPhyDynamicsWorld,
	#superclass : #WTDynamicsWorld,
	#instVars : [
		'physicsEngine',
		'handle',
		'rigidBodies',
		'onSimulation',
		'kinematicObjects'
	],
	#category : 'WodenEngine-Physics-AbstractPhysics'
}

{ #category : #adding }
WTAPhyDynamicsWorld >> addRigidBody: rigidBody [
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

{ #category : #accessing }
WTAPhyDynamicsWorld >> gravity: gravity [
	handle setGravity: gravity x y: gravity y z: gravity z
]

{ #category : #accessing }
WTAPhyDynamicsWorld >> handle [
	^ handle
]

{ #category : #accessing }
WTAPhyDynamicsWorld >> handle: anObject [
	handle := anObject
]

{ #category : #initialization }
WTAPhyDynamicsWorld >> initialize [
	super initialize.
	rigidBodies := OrderedCollection new.
	kinematicObjects := OrderedCollection new.
	onSimulation := false.
]

{ #category : #accessing }
WTAPhyDynamicsWorld >> physicsEngine [
	^ physicsEngine
]

{ #category : #accessing }
WTAPhyDynamicsWorld >> physicsEngine: anObject [
	physicsEngine := anObject
]

{ #category : #rendering }
WTAPhyDynamicsWorld >> simulateTime: delta [
	onSimulation := true.
	[
		handle stepSimulation: delta max_sub_steps: 2 fixed_time_step: 1.0/120.0.
		rigidBodies do: [ :body | self updateSceneNodeFromRigidBody: body ]
	] ensure: [ onSimulation := false ]
]

{ #category : #rendering }
WTAPhyDynamicsWorld >> updateRigidBodyFromSceneNode: rigidBody [
	| transform |
	rigidBody sceneNode ifNil: [ ^ self ].
	
	transform := physicsEngine convertWMTransform: rigidBody sceneNode transform.
	rigidBody handle first setTransformFrom: transform.
	rigidBody handle second setTransformFrom: transform.
]

{ #category : #rendering }
WTAPhyDynamicsWorld >> updateSceneNodeFromRigidBody: rigidBody [
	| motionState rawTransform |
	rigidBody sceneNode ifNil: [ ^ self ].
	
	motionState := rigidBody handle second.
	rawTransform := APHYTransform new.
	motionState getTransformInto: rawTransform.
	rigidBody sceneNode
		transform: (physicsEngine convertTransform: rawTransform)
]
