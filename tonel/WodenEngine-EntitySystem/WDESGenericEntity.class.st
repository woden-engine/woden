Class {
	#name : #WDESGenericEntity,
	#superclass : #WDESAbstractEntity,
	#traits : 'TWDCTransformationManipulationMethods',
	#classTraits : 'TWDCTransformationManipulationMethods classTrait',
	#instVars : [
		'typeName',
		'transform',
		'sceneNode',
		'physicsWorldObject',
		'physicsType'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #building }
WDESGenericEntity >> addComponentWithCollisionShape: collisionShape [
	^ self addComponent: (self createComponentWithCollisionShape: collisionShape)
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
WDESGenericEntity >> addGenericObjectAt: position with: aBlock [
	| entity |
	entity := WDESGenericEntity new
		transform: (ReversibleAffineTransform3dF32 identity translation: position).
	self addChild: entity.
	aBlock value: entity.
	^ entity
]

{ #category : #building }
WDESGenericEntity >> addModelLibraryNamed: modelLibraryName nodeNamed: modelNodeName [
	^ self addModelLibraryNamed: modelLibraryName nodeNamed: modelNodeName with: []
]

{ #category : #building }
WDESGenericEntity >> addModelLibraryNamed: modelLibraryName nodeNamed: modelNodeName with: aBlock [
	| component |
	component := WDESModelLibraryNodeInstanceComponent new
		modelLibraryName: modelLibraryName;
		modelNodeName: modelNodeName;
		yourself.
	self addComponent: component.
	aBlock value: component.
	component collisionShape ifNotNil: [ :collsionShape |
		self addComponentWithCollisionShape: collsionShape
	].
	
	^ component
]

{ #category : #building }
WDESGenericEntity >> addPlayerStartPointAt: position [
	^ self addPointEntityWithType: EntityTypeName_PlayerStartPoint at: position
]

{ #category : #building }
WDESGenericEntity >> addPointEntityWithType: pointEntityTypeName at: position [
	| entity |
	entity := WDESPointEntity new
		typeName: pointEntityTypeName;
		transform: (ReversibleAffineTransform3dF32 identity translation: position ).
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
		makeRigidBodyWithMass: 1.0;
		transform: (ReversibleAffineTransform3dF32 identity translation: position).
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
WDESGenericEntity >> addSoundSourceComponentAt: location with: aBlock [
	| soundComponent |
	soundComponent := WDESSoundSourceComponent new position: location.
	self addComponent: soundComponent.
	aBlock value: soundComponent.
	^ soundComponent
]

{ #category : #building }
WDESGenericEntity >> addUseActuationBoxVolume: boxVolume withAction: actionBlock [
	^ self addComponent: (WDESUseActuationBoxVolumeComponent new
		boxVolume: boxVolume;
		actionBlock: actionBlock;
		yourself)
]

{ #category : #building }
WDESGenericEntity >> addWaterVolumeAt: position with: aBlock [
	| entity waterComponent |
	entity := WDESVolumeSensorEntity new
		transform: (ReversibleAffineTransform3dF32 identity translation: position).
	self addChild: entity.
	waterComponent := entity addComponent: (WDESWaterVolumeSensorBehaviorComponent new).
	aBlock cull: entity cull: waterComponent.
	^ entity
]

{ #category : #physics }
WDESGenericEntity >> addedToPhysicsWorld: physicsWorld [
	physicsWorldObject ifNotNil: [ physicsWorldObject addToPhysicsWorld: physicsWorld ].
	super addedToPhysicsWorld: physicsWorld.

]

{ #category : #physics }
WDESGenericEntity >> applyCollisionShapeToRigidBody: collisionShapeComponent [
	physicsWorldObject ifNotNil: [ 
		self physicsWorld ifNotNil: [ :physicsWorld | physicsWorldObject removeFromPhysicsWorld: physicsWorld ]
	].

	physicsWorldObject := WDPhyRigidBody new
		mass: (self isRigidBodyPhysicsObject ifTrue: [ self rigidBodyMass ] ifFalse: [ 0.0 ]);
		sceneNode: self;
		shape: collisionShapeComponent collisionShape;
		yourself.
	
	self isStaticPhysicsObject ifTrue: [ physicsWorldObject makeStaticCollisionObject ].
	self isKinematicPhysicsObject ifTrue: [ physicsWorldObject
		makeKinematicCollisionObject;
		preSimulationAction: [ :delta |
			self prePhysicsTick: delta
		];
		postSimulationAction: [ :delta :body |
			self postPhysicsTick: delta
		]
	].
	self isRigidBodyPhysicsObject ifTrue: [ physicsWorldObject useDefaultCollisionGroup ].
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
WDESGenericEntity >> buildParticleSystemWith: aBlock [
	| renderable component |
	renderable := WDCParticleSystemRenderable new.
	aBlock value: renderable.
	
	component := WDESStaticRenderableSceneNodeComponent new renderable: renderable.
	self addComponent: component.

	^ component
	
]

{ #category : #building }
WDESGenericEntity >> buildTerrainMeshWith: aBlock [
	| builder renderable component |
	builder := WDCTerrainMeshBuilder for: self engine.
	aBlock value: builder.
	renderable := builder terrainMesh.
	
	component := WDESStaticRenderableSceneNodeComponent new renderable: renderable.
	self addComponent: component.
	
	builder collisionShape ifNotNil: [ :collisionShape |
		self addComponentWithCollisionShape: collisionShape
	].
	
	^ component
	
]

{ #category : #building }
WDESGenericEntity >> buildTerrainMeshWithData: terrainData withMaterial: terrainMaterial [
	| renderable component |
	
	renderable := terrainData createTerrainMeshWithMaterial: terrainMaterial .
	
	component := WDESStaticRenderableSceneNodeComponent new renderable: renderable.
	self addComponent: component.
	
	terrainData collisionShape ifNotNil: [ :collisionShape |
		self addComponentWithCollisionShape: collisionShape
	].
	
	^ component
	
]

{ #category : #building }
WDESGenericEntity >> buildWaterMeshWith: aBlock [
	| builder renderable component |
	builder := WDCTerrainMeshBuilder for: self engine.
	aBlock value: builder.
	renderable := builder waterMesh.
	
	component := WDESStaticRenderableSceneNodeComponent new renderable: renderable.
	self addComponent: component.
	
	builder collisionShape ifNotNil: [ :collisionShape |
		self addComponentWithCollisionShape: collisionShape
	].
	
	^ component
	
]

{ #category : #building }
WDESGenericEntity >> createComponentWithCollisionShape: collisionShape [
	self isStaticPhysicsObject ifTrue: [
		^ WDESStaticCollisionObject new
			collisionShape: collisionShape;
			yourself
	].
	self isKinematicPhysicsObject ifTrue: [
		^ WDESKinematicObjectCollisionShape new
			collisionShape: collisionShape;
			yourself
	].
	self assert: self isRigidBodyPhysicsObject.

	^ WDESRigidBodyCollisionShape new
		collisionShape: collisionShape;
		yourself
]

{ #category : #directions }
WDESGenericEntity >> forwardDirection [
	^ transform transformVector: (Float32x3 z: 1.0)
]

{ #category : #initialization }
WDESGenericEntity >> initialize [
	super initialize.
	transform := ReversibleAffineTransform3dF32 identity.
	self makeStaticPhysicsObject
]

{ #category : #accessing }
WDESGenericEntity >> isKinematicPhysicsObject [
	^ physicsType == #kinematic
]

{ #category : #accessing }
WDESGenericEntity >> isRigidBodyPhysicsObject [
	^ physicsType isArray and: [ physicsType first == #rigidBody]
]

{ #category : #accessing }
WDESGenericEntity >> isStaticPhysicsObject [
	^ physicsType == #static
]

{ #category : #accessing }
WDESGenericEntity >> makeKinematicPhysicsObject [
	^ physicsType := #kinematic
]

{ #category : #accessing }
WDESGenericEntity >> makeRigidBodyWithMass: mass [
	physicsType := {#rigidBody . mass}
]

{ #category : #accessing }
WDESGenericEntity >> makeStaticPhysicsObject [
	^ physicsType := #static
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

{ #category : #accessing }
WDESGenericEntity >> position [
	^ transform translation
]

{ #category : #physics }
WDESGenericEntity >> postPhysicsTick: delta [
	components do: [ :comp | comp postPhysicsTick: delta ]
]

{ #category : #physics }
WDESGenericEntity >> prePhysicsTick: delta [
	components do: [ :comp | comp prePhysicsTick: delta ]
]

{ #category : #physics }
WDESGenericEntity >> removedFromPhysicsWorld: physicsWorld [
	physicsWorldObject ifNotNil: [ physicsWorldObject removeFromPhysicsWorld: physicsWorld ].
	super removedFromPhysicsWorld: physicsWorld.

]

{ #category : #accessing }
WDESGenericEntity >> rigidBodyMass [
	^ physicsType second
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
	^ transform copy
]

{ #category : #accessing }
WDESGenericEntity >> transform: newTransform [
	transform := newTransform.
	self transformChanged
]

{ #category : #accessing }
WDESGenericEntity >> transformChanged [
	sceneNode ifNotNil: [ sceneNode transform: transform copy ].
	components do: [ :comp | comp entityTransformChanged ].
	physicsWorldObject ifNotNil: [ physicsWorldObject sceneNodeTransformChanged ].
]

{ #category : #transforming }
WDESGenericEntity >> translateTo: translation [
	transform translation: translation.
	self transformChanged
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
