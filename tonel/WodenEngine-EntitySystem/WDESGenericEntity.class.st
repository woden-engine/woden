Class {
	#name : #WDESGenericEntity,
	#superclass : #WDESAbstractEntity,
	#instVars : [
		'typeName',
		'transform',
		'sceneNode',
		'physicsWorldObject',
		'mass'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #building }
WDESGenericEntity >> addComponentWithCollisionShape: collisionShape [
	mass ~= 0.0 ifTrue: [ 
		self addComponent: (WDESRigidBodyCollisionShape new
			collisionShape: collisionShape)
	] ifFalse: [ 
		self addComponent: (WDESStaticCollisionObject new
			collisionShape: collisionShape)
	].


]

{ #category : #building }
WDESGenericEntity >> addDirectionalLightWith: aBlock [
	| lightComponent |
	lightComponent := WDESDirectionalLightSourceSceneNodeComponent new.
	aBlock value: lightComponent.
	self addComponent: lightComponent.
	^ lightComponent
]

{ #category : #building }
WDESGenericEntity >> addPlayerStartPointAt: position [
	^ self addPointEntityWithType: EntityTypeName_InfoPlayerStart at: position
]

{ #category : #building }
WDESGenericEntity >> addPointEntityWithType: pointEntityTypeName at: position [
	| entity |
	entity := WDESPointEntity new
		typeName: pointEntityTypeName;
		transform: (WMReversibleAffineTransformF identity translation: position ).
	self addChild: entity.
	^ entity
]

{ #category : #building }
WDESGenericEntity >> addPointLightAt: position with: aBlock [
	| lightComponent |
	lightComponent := WDESPointLightSourceSceneNodeComponent new.
	lightComponent position: position.
	aBlock value: lightComponent.
	self addComponent: lightComponent.
	^ lightComponent
]

{ #category : #building }
WDESGenericEntity >> addRigidBodyAt: position with: aBlock [
	| entity |
	entity := WDESGenericEntity new
		mass: 1.0;
		transform: (WMReversibleAffineTransformF identity translation: position).
	self addChild: entity.
	aBlock value: entity.
	^ entity
]

{ #category : #building }
WDESGenericEntity >> addSkyBoxWithTexture: aTexture [
	| component |
	component := WDESTexturedSkyboxComponent new texture: aTexture.
	self addComponent: component.
	^ component
]

{ #category : #building }
WDESGenericEntity >> addWaterVolumeAt: position with: aBlock [
	| entity |
	entity := WDESWaterVolumeEntity new
		transform: (WMReversibleAffineTransformF identity translation: position).
	self addChild: entity.
	aBlock value: entity.
	^ entity
]

{ #category : #physics }
WDESGenericEntity >> addedToPhysicsWorld: physicsWorld [
	super addedToPhysicsWorld: physicsWorld.
	physicsWorldObject ifNotNil: [ physicsWorldObject addToPhysicsWorld: physicsWorld ]
]

{ #category : #physics }
WDESGenericEntity >> applyCollisionShapeToRigidBody: collisionShapeComponent [
	physicsWorldObject ifNotNil: [ 
		self physicsWorld ifNotNil: [ :physicsWorld | physicsWorldObject removeFromPhysicsWorld: physicsWorld ]
	].

	physicsWorldObject := WDPhyRigidBody new
		mass: mass;
		sceneNode: self;
		shape: collisionShapeComponent collisionShape;
		yourself.
	self physicsWorld ifNotNil: [ :physicsWorld | physicsWorldObject addToPhysicsWorld: physicsWorld ]
]

{ #category : #building }
WDESGenericEntity >> buildGenericMeshWith: aBlock [
	| builder renderable component |
	builder := WDCComplexGenericMeshBuilder for: self engine.
	aBlock value: builder.
	renderable := builder mesh.
	
	component := WDESStaticRenderableSceneNodeComponent new renderable: renderable.
	self addComponent: component.
	
	builder collisionShape ifNotNil: [ :collisionShape |
		self addComponentWithCollisionShape: collisionShape
	].
	
	^ component
	
]

{ #category : #building }
WDESGenericEntity >> buildTerrainMeshWith: aBlock [
	| builder renderable component |
	builder := WDCTerrainMeshBuilder for: self engine.
	aBlock value: builder.
	renderable := builder mesh.
	
	component := WDESStaticRenderableSceneNodeComponent new renderable: renderable.
	self addComponent: component.
	
	builder collisionShape ifNotNil: [ :collisionShape |
		self addComponentWithCollisionShape: collisionShape
	].
	
	^ component
	
]

{ #category : #directions }
WDESGenericEntity >> forwardDirection [
	^ transform transformVector3: (WMVector3F z: 1.0)
]

{ #category : #initialization }
WDESGenericEntity >> initialize [
	super initialize.
	transform := WMReversibleAffineTransformF identity.
	mass := 0.0.
]

{ #category : #accessing }
WDESGenericEntity >> mass [
	^ mass
]

{ #category : #accessing }
WDESGenericEntity >> mass: anObject [
	mass := anObject
]

{ #category : #physics }
WDESGenericEntity >> onStateChangeDo: aBlock [
	"This is ignored."
]

{ #category : #accessing }
WDESGenericEntity >> physicsWorldObject [
	^ physicsWorldObject
]

{ #category : #accessing }
WDESGenericEntity >> physicsWorldObject: anObject [
	physicsWorldObject := anObject
]

{ #category : #physics }
WDESGenericEntity >> removedFromPhysicsWorld: physicsWorld [
	physicsWorldObject ifNotNil: [ physicsWorldObject removeFromPhysicsWorld: physicsWorld ].
	super removedFromPhysicsWorld: physicsWorld.

]

{ #category : #accessing }
WDESGenericEntity >> sceneNode [
	^ sceneNode
]

{ #category : #accessing }
WDESGenericEntity >> sceneNode: newSceneNode [
	sceneNode ifNotNil: [ sceneNode removeFromScene ].
	sceneNode := newSceneNode.
	sceneNode ifNotNil: [
		"Transcript show: transform translation; cr."
		parent ifNotNil: [ parent validSceneNode addChild: newSceneNode ].
		sceneNode transform: transform copy.
	]
]

{ #category : #accessing }
WDESGenericEntity >> transform [
	^ transform
]

{ #category : #accessing }
WDESGenericEntity >> transform: newTransform [
	transform := newTransform.
	
	sceneNode ifNotNil: [ sceneNode transform: newTransform copy ].
]

{ #category : #accessing }
WDESGenericEntity >> typeName [
	^ typeName
]

{ #category : #accessing }
WDESGenericEntity >> typeName: anObject [
	typeName := anObject
]

{ #category : #'as yet unclassified' }
WDESGenericEntity >> validSceneNode [
	sceneNode ifNil: [ self sceneNode: WDSGSpatialObject new ].
	^ sceneNode
]
