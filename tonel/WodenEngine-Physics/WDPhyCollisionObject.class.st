Class {
	#name : #WDPhyCollisionObject,
	#superclass : #WDPhyObject,
	#instVars : [
		'shape',
		'position',
		'preSimulationAction',
		'postSimulationAction',
		'orientation',
		'collisionFilterGroup',
		'collisionFilterMask',
		'sceneNode',
		'hasCollisionResponse',
		'isStaticObject',
		'isCharacterObject',
		'isKinematicObject',
		'hasDebugDrawing',
		'ownerPhysicsWorld'
	],
	#classVars : [
		'AllCollisionsGroupMask',
		'CharacterCollisionGroup',
		'CharacterCollisionGroupFilterMask',
		'DebrisCollisionGroup',
		'DebrisCollisionGroupFilterMask',
		'DefaultCollisionGroup',
		'DefaultCollisionGroupFilterMask',
		'KinematicCollisionGroup',
		'KinematicCollisionGroupFilterMask',
		'SensorTriggerCollisionGroup',
		'SensorTriggerCollisionGroupFilterMask',
		'StaticCollisionGroup',
		'StaticCollisionGroupFilterMask'
	],
	#category : #'WodenEngine-Physics-Interface'
}

{ #category : #'class initialization' }
WDPhyCollisionObject class >> initialize [
	DefaultCollisionGroup := 1.
	StaticCollisionGroup := 2.
	KinematicCollisionGroup := 4.
	DebrisCollisionGroup := 8.
	SensorTriggerCollisionGroup := 16.
	CharacterCollisionGroup := 32.
	
	AllCollisionsGroupMask := -1.
	DefaultCollisionGroupFilterMask := AllCollisionsGroupMask.
	StaticCollisionGroupFilterMask := AllCollisionsGroupMask bitClear: StaticCollisionGroup | SensorTriggerCollisionGroup.
	KinematicCollisionGroupFilterMask := AllCollisionsGroupMask.
	DebrisCollisionGroupFilterMask := AllCollisionsGroupMask.
	SensorTriggerCollisionGroupFilterMask := AllCollisionsGroupMask.
	CharacterCollisionGroupFilterMask := AllCollisionsGroupMask.
	
]

{ #category : #removing }
WDPhyCollisionObject >> addToPhysicsWorld: physicsWorld [
	self assert: ownerPhysicsWorld isNil.
	ownerPhysicsWorld := physicsWorld.
	physicsWorld addCollisionObject: self.

]

{ #category : #'collision groups' }
WDPhyCollisionObject >> angularVelocity: velocity [
	physicsEngine setCollisionObject: self angularVelocity: velocity
]

{ #category : #accessing }
WDPhyCollisionObject >> applyTransformInHandle [
	physicsEngine ifNotNil: [
		physicsEngine
			activateCollisionObject: self;
			setCollisionObject: self position: position;
			setCollisionObject: self orientation: orientation
	]
]

{ #category : #accessing }
WDPhyCollisionObject >> collisionFilterGroup [
	^ collisionFilterGroup
]

{ #category : #accessing }
WDPhyCollisionObject >> collisionFilterGroup: anObject [
	collisionFilterGroup := anObject
]

{ #category : #accessing }
WDPhyCollisionObject >> collisionFilterMask [
	^ collisionFilterMask
]

{ #category : #accessing }
WDPhyCollisionObject >> collisionFilterMask: anObject [
	collisionFilterMask := anObject
]

{ #category : #accessing }
WDPhyCollisionObject >> hasCollisionResponse [
	^ hasCollisionResponse
]

{ #category : #accessing }
WDPhyCollisionObject >> hasCollisionResponse: anObject [
	hasCollisionResponse := anObject
]

{ #category : #accessing }
WDPhyCollisionObject >> hasDebugDrawing [
	^ hasDebugDrawing
]

{ #category : #accessing }
WDPhyCollisionObject >> hasDebugDrawing: anObject [
	hasDebugDrawing := anObject
]

{ #category : #testing }
WDPhyCollisionObject >> hasKinematicSimulation [
	^ preSimulationAction isNotNil or: [ postSimulationAction isNotNil ]
]

{ #category : #accessing }
WDPhyCollisionObject >> hasValidHandle [
	^ handle ~~ nil and: [ handle isValid ]
]

{ #category : #initialization }
WDPhyCollisionObject >> initialize [
	super initialize.
	position := Float32x3 zero.
	orientation := Float32x3x3 identity.
	
	hasCollisionResponse := true.
	isStaticObject := false.
	isCharacterObject := false.
	isKinematicObject := false.
	hasDebugDrawing := true.
	self useDefaultCollisionGroup
]

{ #category : #accessing }
WDPhyCollisionObject >> isCharacterObject [
	^ isCharacterObject
]

{ #category : #accessing }
WDPhyCollisionObject >> isCharacterObject: anObject [
	isCharacterObject := anObject
]

{ #category : #testing }
WDPhyCollisionObject >> isGhostObject [
	^ false
]

{ #category : #testing }
WDPhyCollisionObject >> isGhostObjectWithPairCache [
	^ false
]

{ #category : #accessing }
WDPhyCollisionObject >> isKinematicObject [
	^ isKinematicObject
]

{ #category : #accessing }
WDPhyCollisionObject >> isKinematicObject: anObject [
	isKinematicObject := anObject
]

{ #category : #testing }
WDPhyCollisionObject >> isOnPhysicsEngineSimulation [
	^ ownerPhysicsWorld isNotNil and: [ ownerPhysicsWorld isOnPhysicsEngineSimulation ]
]

{ #category : #testing }
WDPhyCollisionObject >> isRigidBody [
	^ false
]

{ #category : #testing }
WDPhyCollisionObject >> isSensorOrTrigger [
	^ collisionFilterGroup == SensorTriggerCollisionGroup
]

{ #category : #accessing }
WDPhyCollisionObject >> isStaticObject [
	^ isStaticObject
]

{ #category : #accessing }
WDPhyCollisionObject >> isStaticObject: anObject [
	isStaticObject := anObject
]

{ #category : #'collision groups' }
WDPhyCollisionObject >> linearVelocity: velocity [
	physicsEngine setCollisionObject: self linearVelocity: velocity
]

{ #category : #'collision groups' }
WDPhyCollisionObject >> makeCharacterCollisionObject [
	self
		useCharacterCollisionGroup;
		isCharacterObject: true
]

{ #category : #'collision groups' }
WDPhyCollisionObject >> makeKinematicCollisionObject [
	self
		useKinematicCollisionGroup;
		isKinematicObject: true
]

{ #category : #'collision groups' }
WDPhyCollisionObject >> makeSensorTriggerCollisionObject [
	self
		hasCollisionResponse: false;
		useSensorTriggerCollisionGroup
]

{ #category : #'collision groups' }
WDPhyCollisionObject >> makeStaticCollisionObject [
	self
		isStaticObject: true;
		useStaticCollisionGroup
]

{ #category : #accessing }
WDPhyCollisionObject >> orientation: aMatrix [
	orientation := aMatrix.
	self applyTransformInHandle.
]

{ #category : #'transform updating' }
WDPhyCollisionObject >> physicsEngineTransformChangedTo: aTransform [
	position := aTransform translation.
	orientation := aTransform matrix.

	sceneNode ifNil: [ ^ self ].
	sceneNode transform: aTransform
]

{ #category : #accessing }
WDPhyCollisionObject >> position [
	^ physicsEngine ifNotNil: [ physicsEngine getCollisionObjectPosition: self ] ifNil: [ position ]
]

{ #category : #accessing }
WDPhyCollisionObject >> position: aPosition [
	position := aPosition.
	self applyTransformInHandle
]

{ #category : #rendering }
WDPhyCollisionObject >> postSimulateTime: delta [
	postSimulationAction ifNotNil: [ postSimulationAction cull: delta cull: self ]
]

{ #category : #accessing }
WDPhyCollisionObject >> postSimulationAction [
	^ postSimulationAction
]

{ #category : #accessing }
WDPhyCollisionObject >> postSimulationAction: anObject [
	postSimulationAction := anObject
]

{ #category : #rendering }
WDPhyCollisionObject >> preSimulateTime: delta [
	preSimulationAction ifNotNil: [ preSimulationAction cull: delta cull: self ]
]

{ #category : #accessing }
WDPhyCollisionObject >> preSimulationAction [
	^ preSimulationAction
]

{ #category : #accessing }
WDPhyCollisionObject >> preSimulationAction: anObject [
	preSimulationAction := anObject
]

{ #category : #removing }
WDPhyCollisionObject >> removeFromPhysicsWorld: physicsWorld [
	physicsWorld removeCollisionObject: self
]

{ #category : #'as yet unclassified' }
WDPhyCollisionObject >> retrieveTransformFromPhysicsEngine [
]

{ #category : #accessing }
WDPhyCollisionObject >> sceneNode [
	^ sceneNode
]

{ #category : #accessing }
WDPhyCollisionObject >> sceneNode: anObject [
	sceneNode := anObject.
	self transform: sceneNode transform
]

{ #category : #'transform updating' }
WDPhyCollisionObject >> sceneNodeTransformChanged [
	sceneNode ifNil: [ ^ self ].
	self isOnPhysicsEngineSimulation ifTrue: [ ^ self ].
	self transform: sceneNode transform
]

{ #category : #accessing }
WDPhyCollisionObject >> shape [
	
	^ shape
]

{ #category : #accessing }
WDPhyCollisionObject >> shape: anObject [
	
	shape := anObject
]

{ #category : #accessing }
WDPhyCollisionObject >> transform: aTransform [
	position := aTransform translation.
	orientation := aTransform matrix.
	self applyTransformInHandle.
]

{ #category : #'collision groups' }
WDPhyCollisionObject >> useCharacterCollisionGroup [
	collisionFilterGroup := CharacterCollisionGroup.
	collisionFilterMask := CharacterCollisionGroupFilterMask.
]

{ #category : #'collision groups' }
WDPhyCollisionObject >> useDebrisCollisionGroup [
	collisionFilterGroup := DebrisCollisionGroup.
	collisionFilterMask := DebrisCollisionGroupFilterMask.
]

{ #category : #'collision groups' }
WDPhyCollisionObject >> useDefaultCollisionGroup [
	collisionFilterGroup := DefaultCollisionGroup.
	collisionFilterMask := DefaultCollisionGroupFilterMask.
]

{ #category : #'collision groups' }
WDPhyCollisionObject >> useKinematicCollisionGroup [
	collisionFilterGroup := KinematicCollisionGroup.
	collisionFilterMask := KinematicCollisionGroupFilterMask.
]

{ #category : #'collision groups' }
WDPhyCollisionObject >> useSensorTriggerCollisionGroup [
	collisionFilterGroup := SensorTriggerCollisionGroup.
	collisionFilterMask := SensorTriggerCollisionGroupFilterMask.
]

{ #category : #'collision groups' }
WDPhyCollisionObject >> useStaticCollisionGroup [
	collisionFilterGroup := StaticCollisionGroup.
	collisionFilterMask := StaticCollisionGroupFilterMask.
]
