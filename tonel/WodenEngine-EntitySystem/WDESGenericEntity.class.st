Class {
	#name : #WDESGenericEntity,
	#superclass : #WDESAbstractEntity,
	#instVars : [
		'typeName',
		'transform',
		'sceneNode',
		'physicsWorldObject'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

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
WDESGenericEntity >> buildGenericMeshWith: aBlock [
	| builder renderable component |
	builder := WDCComplexGenericMeshBuilder for: self engine.
	aBlock value: builder.
	renderable := builder mesh.
	
	component := WDESStaticRenderableSceneNodeComponent new renderable: renderable.
	self addComponent: component.
	
	builder collisionShape ifNotNil: [ :collisionShape |
		self addComponent: (WDESStaticCollisionObject new
			collisionShape: collisionShape)
	].
	
	^ component
	
]

{ #category : #initialization }
WDESGenericEntity >> initialize [
	super initialize.
	transform := WMReversibleAffineTransformF identity.
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
