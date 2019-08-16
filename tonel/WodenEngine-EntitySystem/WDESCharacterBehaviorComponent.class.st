Class {
	#name : #WDESCharacterBehaviorComponent,
	#superclass : #WDESBehaviorComponent,
	#traits : 'TEnvironmentSensitiveBehavior',
	#classTraits : 'TEnvironmentSensitiveBehavior classTrait',
	#instVars : [
		'headAngle',
		'linearVelocity',
		'linearAcceleration',
		'collisionShape',
		'ghostObject',
		'physicsCharacterController',
		'headOrientation',
		'bodyOrientation',
		'headAngularVelocity',
		'running',
		'displacementStrategy',
		'isUnderwater',
		'isHeadUnderwater',
		'walkingDisplacementStrategy',
		'swimmingDisplacementStrategy',
		'leftStickDirection',
		'rightStickDirection',
		'linearDamping'
	],
	#category : #'WodenEngine-EntitySystem-Behaviors'
}

{ #category : #accessing }
WDESCharacterBehaviorComponent class >> halfExtent [
	^ WMVector3D x: 0.3 y: 0.8 z: 0.3
]

{ #category : #accessing }
WDESCharacterBehaviorComponent class >> headPosition [
	^ WMVector3F y: self halfExtent y * 0.9
]

{ #category : #'as yet unclassified' }
WDESCharacterBehaviorComponent >> activateUseActuator [
	| ray |
	ray := self sectorHeadRay.
	self sector usableVolumeRayCastingSet send: #use from: self toFirstHitOf: ray withMaxDistance: 2.0
]

{ #category : #notifications }
WDESCharacterBehaviorComponent >> addedToPhysicsWorld: physicsWorld [
	physicsWorld addGhostObject: self validGhostObject.
	physicsWorld addCharacterController: self validPhysicsCharacterController.
	ghostObject sceneNode: ownerEntity.
	
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> bodyOrientation [
	^ bodyOrientation
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> bodyOrientation: anObject [
	bodyOrientation := anObject
]

{ #category : #testing }
WDESCharacterBehaviorComponent >> canFly [
	^ false
]

{ #category : #testing }
WDESCharacterBehaviorComponent >> canSwim [
	^ true
]

{ #category : #initialization }
WDESCharacterBehaviorComponent >> createCollisionShape [
	collisionShape := WDPhyCapsuleYCollisionShape new halfExtent: self halfExtent; yourself
]

{ #category : #initialization }
WDESCharacterBehaviorComponent >> createGhostObject [
	ghostObject := WDPhyGhostObjectWithPairCache new.
	ghostObject
		makeCharacterCollisionObject;
		shape: self validCollisionShape
]

{ #category : #initialization }
WDESCharacterBehaviorComponent >> createPhysicsCharacterController [
	physicsCharacterController := WDPhyCharacterController new
		ghostObject: ghostObject;
		shape: collisionShape;
		preSimulationAction: [ :delta |
			self prePhysicsTick: delta
		];
		postSimulationAction: [ :delta :body |
			self postPhysicsTick: delta
		];
		yourself.
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> displacementStrategy [
	^ displacementStrategy
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> displacementStrategy: aDisplacementStrategy [
	^ displacementStrategy := (aDisplacementStrategy character: self; yourself)
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> ghostObject [
	^ ghostObject
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> globalHeadPosition [
	^ ownerEntity globalTransform transformPosition3: self headPosition
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> halfExtent [
	^ self class halfExtent
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> headAngle [
	^ headAngle copy
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> headAngle: anObject [
	headAngle := anObject
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> headAngularVelocity [
	^ headAngularVelocity copy
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> headAngularVelocity: anObject [
	headAngularVelocity := anObject
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> headOrientation [
	^ headOrientation copy
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> headOrientation: anObject [
	headOrientation := anObject
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> headPosition [
	^ self class headPosition
]

{ #category : #initialization }
WDESCharacterBehaviorComponent >> initialize [
	super initialize.
	headAngle := WMVector3F zero.
	headAngularVelocity := WMVector3F zero.
	
	bodyOrientation := WMMatrix3F identity.
	headOrientation := WMMatrix3F identity.
	
	leftStickDirection := WMVector3F zero.
	rightStickDirection := WMVector3F zero.
	
	linearDamping := 10.0.
	linearVelocity := WMVector3F zero.
	linearAcceleration := WMVector3F zero.
	running := false.
	isUnderwater := false.
	isHeadUnderwater := false.
	self useWalkingDisplacementStrategy.
]

{ #category : #testing }
WDESCharacterBehaviorComponent >> isCharacterBehaviorComponent [
	^ true
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> isHeadUnderwater [
	^ isHeadUnderwater
]

{ #category : #testing }
WDESCharacterBehaviorComponent >> isTickingComponent [
	^ true
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> isUnderwater [
	^ isUnderwater
]

{ #category : #actions }
WDESCharacterBehaviorComponent >> jump [
	displacementStrategy jump

]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> leftStickDirection [
	^ leftStickDirection
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> leftStickDirection: anObject [
	leftStickDirection := anObject
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> linearAcceleration [
	^ linearAcceleration copy
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> linearAcceleration: anObject [
	linearAcceleration := anObject
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> linearDamping [
	^ linearDamping
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> linearDamping: anObject [
	linearDamping := anObject
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> linearVelocity [
	^ linearVelocity copy
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> linearVelocity: anObject [
	linearVelocity := anObject
]

{ #category : #events }
WDESCharacterBehaviorComponent >> onUnderwaterVolume: underwaterVolumeComponent [
	isUnderwater := true.
	isHeadUnderwater ifFalse: [
		isHeadUnderwater := underwaterVolumeComponent ownerEntity sceneNode globalBoundingBox includesPoint: self globalHeadPosition.
		(isHeadUnderwater and: [ ownerEntity isPlayerEntity ]) ifTrue: [
			ownerEntity currentEnvironmentFog: underwaterVolumeComponent environmentFogSettings
		].
	].

]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> physicsCharacterController [
	^ physicsCharacterController
]

{ #category : #simulation }
WDESCharacterBehaviorComponent >> postPhysicsTick: delta [
	displacementStrategy postPhysicsTick: delta.
	
	ownerEntity findCameraSceneNodeComponentOrNil ifNotNil: [ :cameraNodeComponent |
		cameraNodeComponent validSceneNode
			transform: (WMReversibleAffineTransformF identity
				orthonormal: headOrientation translation: self headPosition)
	].
]

{ #category : #simulation }
WDESCharacterBehaviorComponent >> prePhysicsTick: delta [
	headAngularVelocity := WMVector3F x: rightStickDirection y y: rightStickDirection x negated z: 0.0.
	
	headAngle := headAngle + (headAngularVelocity * delta).
	headAngle x: (headAngle x min: Float halfPi max: Float halfPi negated).
	
	displacementStrategy prePhysicsTick: delta.

	ghostObject
		orientation: bodyOrientation;
		position: ownerEntity transform translation.
	physicsCharacterController
		buoyancy: displacementStrategy buoyancy;
		linearVelocity: linearVelocity.

	"If we are underwater, then before the postPhysicsTick, this will be set to true."
	ownerEntity isPlayerEntity ifTrue: [ ownerEntity currentEnvironmentFog: nil ].
	isUnderwater := false.
	isHeadUnderwater := false.
]

{ #category : #notifications }
WDESCharacterBehaviorComponent >> removedFromPhysicsWorld: physicsWorld [
	ghostObject ifNotNil: [ physicsWorld removeGhostObject: ghostObject ].
	physicsCharacterController ifNotNil: [ physicsWorld removeCharacterController: physicsCharacterController ].
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> rightStickDirection [
	^ rightStickDirection
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> rightStickDirection: anObject [
	rightStickDirection := anObject
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> running [
	^ running
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> running: anObject [
	running := anObject
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> sectorHeadDirection [
	^ ownerEntity sectorTransform transformVector3: (headOrientation transformVector3: (WMVector3F z: -1.0))
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> sectorHeadPosition [
	^ ownerEntity sectorTransform transformPosition3: self headPosition
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> sectorHeadRay [
	^ WMRayF origin: self sectorHeadPosition direction: self sectorHeadDirection
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> swimmingDisplacementStrategy [
	^ swimmingDisplacementStrategy ifNil: [swimmingDisplacementStrategy := WDESCharacterSwimmingDisplacementStrategy new]
]

{ #category : #simulation }
WDESCharacterBehaviorComponent >> tick: delta [
	displacementStrategy tick: delta
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> useSwimmingDisplacementStrategy [
	^ self displacementStrategy: self swimmingDisplacementStrategy
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> useWalkingDisplacementStrategy [
	^ self displacementStrategy: self walkingDisplacementStrategy
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> validCollisionShape [
	collisionShape ifNil: [self createCollisionShape].
	^ collisionShape
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> validGhostObject [
	ghostObject ifNil: [ self createGhostObject ].
	^ ghostObject
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> validPhysicsCharacterController [
	physicsCharacterController ifNil: [self createPhysicsCharacterController].
	^ physicsCharacterController
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> walkingDisplacementStrategy [
	^ walkingDisplacementStrategy ifNil: [walkingDisplacementStrategy := WDESCharacterWalkingDisplacementStrategy new]
]
