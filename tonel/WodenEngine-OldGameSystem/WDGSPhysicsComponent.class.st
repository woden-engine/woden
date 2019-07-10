Class {
	#name : #WDGSPhysicsComponent,
	#superclass : #WDGSComponent,
	#instVars : [
		'physicsType',
		'invalidCollisionShapes',
		'collisionShape',
		'stateChangeListener',
		'mass',
		'explicitCollisionShape',
		'renderObjectTransform',
		'physicsObject'
	],
	#category : #'WodenEngine-OldGameSystem-Level'
}

{ #category : #serialization }
WDGSPhysicsComponent class >> jsonTypeName [
	^ 'physicsComponent'
]

{ #category : #adding }
WDGSPhysicsComponent >> addedToEntity: anEntity [
	super addedToEntity: anEntity.
	anEntity ensureSpatialObject.
	anEntity worldEntity ifTrue: [ self makeStatic ]
]

{ #category : #converting }
WDGSPhysicsComponent >> asJsonData [
	^ OrderedDictionary newFromPairs: {
		'type' . 'physicsComponent'.
	 }
]

{ #category : #'collision shape' }
WDGSPhysicsComponent >> boxCollisionShape: aBox [
	| center halfExtent |
	center := aBox center.
	halfExtent := aBox halfExtent.
	renderObjectTransform := WMReversibleAffineTransformD identity translation: center asWMVector3D negated.
	self collisionShape: (WDPhyBoxCollisionShape new halfExtent: halfExtent asWMVector3F)
]

{ #category : #accessing }
WDGSPhysicsComponent >> bucket [
	^ #physicsComponent
]

{ #category : #accessing }
WDGSPhysicsComponent >> collisionShape: aExplicitCollisionShape [
	collisionShape := aExplicitCollisionShape.
	explicitCollisionShape := true.
]

{ #category : #'physics hooks' }
WDGSPhysicsComponent >> convertTransformFromRendering: transform [
	renderObjectTransform ifNil: [ ^ transform asWMReversibleAffineTransformF ].
	^ (renderObjectTransform inverseTransformTransform: transform) asWMReversibleAffineTransformF
]

{ #category : #'physics hooks' }
WDGSPhysicsComponent >> convertTransformIntoRendering: transform [
	renderObjectTransform ifNil: [ ^ transform asWMReversibleAffineTransformD ].
	^ (renderObjectTransform transformTransform: transform asWMReversibleAffineTransformD)
]

{ #category : #physics }
WDGSPhysicsComponent >> createRigidBodyPhysicsObject [
	physicsObject := WDPhyRigidBody new
					sceneNode: self;
					mass: mass;
					shape: collisionShape;
					yourself.
	self validDynamicsWorld addRigidBody: physicsObject
]

{ #category : #physics }
WDGSPhysicsComponent >> createStaticPhysicsObject [
	physicsObject := WDPhyRigidBody new
					sceneNode: self;
					mass: 0.0;
					shape: collisionShape;
					yourself.
	self validDynamicsWorld addRigidBody: physicsObject
]

{ #category : #initialization }
WDGSPhysicsComponent >> initialize [
	self makeNoPhysics.
	self invalidate.
	renderObjectTransform := nil.
	explicitCollisionShape := false.
	mass := 1.0.
]

{ #category : #initialization }
WDGSPhysicsComponent >> invalidate [
	invalidCollisionShapes := true.

]

{ #category : #'physics component type' }
WDGSPhysicsComponent >> isGhost [
	^ physicsType == #ghost
]

{ #category : #'physics component type' }
WDGSPhysicsComponent >> isNoPhysics [
	^ physicsType == #noPhysics
]

{ #category : #'physics component type' }
WDGSPhysicsComponent >> isRigidBody [
	^ physicsType == #rigidBody
]

{ #category : #testing }
WDGSPhysicsComponent >> isSingleton [
	^ true
]

{ #category : #'physics component type' }
WDGSPhysicsComponent >> isStatic [
	^ physicsType == #static
]

{ #category : #'physics component type' }
WDGSPhysicsComponent >> makeGhost [
	self physicsType: #ghost.
]

{ #category : #'physics component type' }
WDGSPhysicsComponent >> makeNoPhysics [
	self physicsType: #noPhysics.
]

{ #category : #'physics component type' }
WDGSPhysicsComponent >> makeRigidBody [
	self physicsType: #rigidBody.
]

{ #category : #'physics component type' }
WDGSPhysicsComponent >> makeStatic [
	self physicsType: #static.
]

{ #category : #accessing }
WDGSPhysicsComponent >> mass [
	^ mass
]

{ #category : #accessing }
WDGSPhysicsComponent >> mass: anObject [
	mass := anObject
]

{ #category : #'physics hooks' }
WDGSPhysicsComponent >> onStateChangeDo: aBlock [
	stateChangeListener := aBlock
]

{ #category : #'physics component type' }
WDGSPhysicsComponent >> physicsType [
	^ physicsType
]

{ #category : #'physics component type' }
WDGSPhysicsComponent >> physicsType: aPhysicsType [
	physicsType := aPhysicsType
]

{ #category : #adding }
WDGSPhysicsComponent >> removedFromMap: aMap [
	physicsObject ifNotNil: [ physicsObject removeFromWorld: self validDynamicsWorld ]

]

{ #category : #'map events' }
WDGSPhysicsComponent >> spawn [
	self isNoPhysics ifTrue: [ ^ self ].
	self validCollisionShape ifNil: [ ^ self ].
	self isStatic ifTrue: [ self createStaticPhysicsObject ].
	self isGhost ifTrue: [ self createGhostPhysicsObject ].
	self isRigidBody ifTrue: [ self createRigidBodyPhysicsObject ].
]

{ #category : #'physics hooks' }
WDGSPhysicsComponent >> transform [
	^ self convertTransformFromRendering: (entity spatialDescription
		ifNil: [ WMReversibleAffineTransformF identity ]
		ifNotNil: [:spatialDesc | spatialDesc transform])
]

{ #category : #'physics hooks' }
WDGSPhysicsComponent >> transform: aTransform [
	entity spatialDescription ifNotNil: [ :spatialDesc |
		spatialDesc transform: (self convertTransformIntoRendering: aTransform)
	]
]

{ #category : #'collision shape' }
WDGSPhysicsComponent >> validCollisionShape [
	| collisionShapeComponents |
	explicitCollisionShape ifTrue: [ ^ collisionShape ].
	invalidCollisionShapes ifFalse: [ ^ collisionShape ].

	collisionShapeComponents := OrderedCollection new.		
	(entity components at: #modeling) do: [ :model |
		model createCollisionShapeComponent ifNotNil: [ :component |
			collisionShapeComponents add: component
		]
	].

	invalidCollisionShapes := false.
	^ collisionShape := WDPhyCompoundCollisionShape withComponents: collisionShapeComponents
]
