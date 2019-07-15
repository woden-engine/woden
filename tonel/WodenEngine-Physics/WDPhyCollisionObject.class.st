Class {
	#name : #WDPhyCollisionObject,
	#superclass : #WDPhyObject,
	#instVars : [
		'shape',
		'position',
		'preSimulationAction',
		'postSimulationAction',
		'orientation'
	],
	#category : #'WodenEngine-Physics-Interface'
}

{ #category : #removing }
WDPhyCollisionObject >> addToPhysicsWorld: physicsWorld [
	physicsWorld addCollisionObject: self
]

{ #category : #accessing }
WDPhyCollisionObject >> applyTransformInHandle [
	physicsEngine ifNotNil: [
		physicsEngine
			setCollisionObject: self position: position;
			setCollisionObject: self orientation: orientation
	]
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
	position := WMVector3F zero.
	orientation := WMMatrix3F identity.
]

{ #category : #testing }
WDPhyCollisionObject >> isGhostObject [
	^ false
]

{ #category : #testing }
WDPhyCollisionObject >> isGhostObjectWithPairCache [
	^ false
]

{ #category : #testing }
WDPhyCollisionObject >> isRigidBody [
	^ false
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
