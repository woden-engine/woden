Class {
	#name : #WDESCharacterBehaviorComponent,
	#superclass : #WDESBehaviorComponent,
	#instVars : [
		'headAngle',
		'linearVelocity',
		'linearAcceleration',
		'linearViscosity',
		'collisionShape',
		'ghostObject',
		'physicsCharacterController'
	],
	#category : #'WodenEngine-EntitySystem-Behaviors'
}

{ #category : #accessing }
WDESCharacterBehaviorComponent class >> halfExtent [
	^ WMVector3D x: 0.3 y: 0.9 z: 0.3
]

{ #category : #accessing }
WDESCharacterBehaviorComponent class >> headPosition [
	^ WMVector3F y: self halfExtent y * 0.9
]

{ #category : #notifications }
WDESCharacterBehaviorComponent >> addedToPhysicsWorld: physicsWorld [
	physicsWorld addGhostObject: self validGhostObject.
	physicsWorld addCharacterController: self validPhysicsCharacterController.
	
]

{ #category : #'map events' }
WDESCharacterBehaviorComponent >> createCollisionShape [
	collisionShape := WDPhyCapsuleYCollisionShape new halfExtent: self halfExtent; yourself
]

{ #category : #'map events' }
WDESCharacterBehaviorComponent >> createGhostObject [
	ghostObject := WDPhyGhostObjectWithPairCache new.
	ghostObject shape: self validCollisionShape
]

{ #category : #'map events' }
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

{ #category : #'map events' }
WDESCharacterBehaviorComponent >> halfExtent [
	^ self class halfExtent
]

{ #category : #initialization }
WDESCharacterBehaviorComponent >> initialize [
	super initialize.
	headAngle := WMVector3F zero.
	linearViscosity := 10.0.
	linearVelocity := WMVector3F zero.
	linearAcceleration := WMVector3F zero.
]

{ #category : #testing }
WDESCharacterBehaviorComponent >> isCharacterBehaviorComponent [
	^ true
]

{ #category : #testing }
WDESCharacterBehaviorComponent >> isTickingComponent [
	^ true
]

{ #category : #actions }
WDESCharacterBehaviorComponent >> jump [
	physicsCharacterController jump
]

{ #category : #'map events' }
WDESCharacterBehaviorComponent >> postPhysicsTick: delta [
	ownerEntity transform: (WMReversibleAffineTransformF identity translation: ghostObject position)
]

{ #category : #'map events' }
WDESCharacterBehaviorComponent >> prePhysicsTick: delta [
	ghostObject position: ownerEntity transform translation.
]

{ #category : #notifications }
WDESCharacterBehaviorComponent >> removedFromPhysicsWorld: physicsWorld [
	ghostObject ifNotNil: [ physicsWorld removeGhostObject: ghostObject ].
	physicsCharacterController ifNotNil: [ physicsWorld removeCharacterController: physicsCharacterController ].
]

{ #category : #simulation }
WDESCharacterBehaviorComponent >> tick: delta [
	"| accel sourcePosition newPosition newTransform |
	accel := (linearAcceleration*linearViscosity) - (linearVelocity*linearViscosity).
	linearVelocity := linearVelocity + (accel * delta).
	sourcePosition := ownerEntity transform translation.
	newPosition := sourcePosition + (linearVelocity * delta).
	newTransform := WMReversibleAffineTransformF identity translation: newPosition.
	ownerEntity transform: newTransform."

]

{ #category : #'map events' }
WDESCharacterBehaviorComponent >> validCollisionShape [
	collisionShape ifNil: [self createCollisionShape].
	^ collisionShape
]

{ #category : #'map events' }
WDESCharacterBehaviorComponent >> validGhostObject [
	ghostObject ifNil: [ self createGhostObject ].
	^ ghostObject
]

{ #category : #'map events' }
WDESCharacterBehaviorComponent >> validPhysicsCharacterController [
	physicsCharacterController ifNil: [self createPhysicsCharacterController].
	^ physicsCharacterController
]
