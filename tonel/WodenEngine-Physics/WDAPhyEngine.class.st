Class {
	#name : #WDAPhyEngine,
	#superclass : #WDPhyPhysicsEngine,
	#instVars : [
		'handle'
	],
	#category : #'WodenEngine-Physics-AbstractPhysics'
}

{ #category : #'as yet unclassified' }
WDAPhyEngine class >> isSupported [
	^ true
]

{ #category : #rendering }
WDAPhyEngine >> buildCollisionShape: collisionShape [
	collisionShape handle: (collisionShape accept: self)
]

{ #category : #rendering }
WDAPhyEngine >> buildRigidBody: rigidBody [
	| collisionShape localInertia motionState rigidBodyHandle |
	collisionShape := self validateCollisionShapeHandle: rigidBody shape.
	localInertia := APHYVector3 new.
	collisionShape computeLocalInertiaInto: rigidBody mass result: localInertia.
	
	motionState := handle createDefaultMotionState.
	rigidBodyHandle := handle createSimpleRigidBodyFrom: rigidBody mass motion_state: motionState collision_shape: collisionShape local_inertia: localInertia.
	
	rigidBody handle: { rigidBodyHandle . motionState }.
]

{ #category : #rendering }
WDAPhyEngine >> convertMatrix3: matrix3 [
	| firstRow secondRow thirdRow |
	firstRow := matrix3 firstRow.
	secondRow := matrix3 secondRow.
	thirdRow := matrix3 thirdRow.
	^ WMMatrix3F
		m11: firstRow x m12: firstRow y m13: firstRow z 
		m21: secondRow x m22: secondRow y m23: secondRow z
		m31: thirdRow x m32: thirdRow y m33: thirdRow z
]

{ #category : #rendering }
WDAPhyEngine >> convertTransform: transform [
	| matrix translation |
	matrix := self convertMatrix3: transform rotation.
	translation := self convertVector3: transform origin.
	^ WMReversibleAffineTransformF new orthonormal: matrix translation: translation
]

{ #category : #rendering }
WDAPhyEngine >> convertVector3: vector3 [
	^ WMVector3F x: vector3 x y: vector3 y z: vector3 z
]

{ #category : #rendering }
WDAPhyEngine >> convertWMMatrix3: matrix [
	^ APHYMatrix3x3 new
		firstRow: (self convertWMVector3: matrix firstRow);
		secondRow: (self convertWMVector3: matrix secondRow);
		thirdRow: (self convertWMVector3: matrix thirdRow);
		yourself
]

{ #category : #rendering }
WDAPhyEngine >> convertWMTransform: transform [
	^ APHYTransform new
		rotation: (self convertWMMatrix3: transform matrix);
		origin: (self convertWMVector3: transform translation);
		yourself
]

{ #category : #rendering }
WDAPhyEngine >> convertWMVector3: vector [
	^ APHYVector3 new
		x: vector x;
		y: vector y;
		z: vector z;
		yourself
]

{ #category : #'as yet unclassified' }
WDAPhyEngine >> createDynamicsWorld [
	| collisionConfiguration collisionDispatcher broadphase constraintSolver world |
	collisionConfiguration := handle createDefaultCollisionConfiguration.
	collisionDispatcher := handle createDefaultCollisionDispatcher: collisionConfiguration.

	broadphase := handle createDefaultBroadphase.
	constraintSolver := handle createDefaultConstraintSolver.

	world := handle createDynamicsWorld: collisionDispatcher broadphase: broadphase constraint_solver: 	constraintSolver collision_configuration: collisionConfiguration.
		
	^ WDAPhyDynamicsWorld new physicsEngine: self; handle: world; yourself
]

{ #category : #accessing }
WDAPhyEngine >> handle [
	^ handle
]

{ #category : #'as yet unclassified' }
WDAPhyEngine >> initialize [
	super initialize.
	handle := APHY firstEngine.
	
]

{ #category : #rendering }
WDAPhyEngine >> validateCollisionShapeHandle: collisionShape [
	(collisionShape handle isNil or: [ collisionShape handle isNull ]) ifTrue: [
		self buildCollisionShape: collisionShape
	].
	^ collisionShape handle
]

{ #category : #rendering }
WDAPhyEngine >> validateRigidBodyHandle: rigidBody [
	(rigidBody handle isNil or: [ rigidBody handle isNull ]) ifTrue: [
		self buildRigidBody: rigidBody
	].
	^ rigidBody handle
]

{ #category : #'collision shape convertion' }
WDAPhyEngine >> visitBoxShape: boxShape [
	^ handle createBoxShape: boxShape halfExtent x half_height: boxShape halfExtent y half_depth: boxShape halfExtent z
]

{ #category : #'collision shape convertion' }
WDAPhyEngine >> visitCompoundShape: compoundShape [
	| compoundHandle localTransform localShape |
	compoundHandle := handle createCompoundShape.
	compoundShape components do: [ :component |
		localTransform := self convertWMTransform: component transform.
		localShape := self validateCollisionShapeHandle: component shape.
		compoundHandle addLocalShapeWithTransformFrom: localShape transform: localTransform.
	].
	^ compoundHandle
]

{ #category : #'collision shape convertion' }
WDAPhyEngine >> visitConvexHullShape: convexHullShape [
	| points |
	points := convexHullShape points.
	^ handle createConvexHullShape: points rawData num_points: points size stride: points elementSize

]
