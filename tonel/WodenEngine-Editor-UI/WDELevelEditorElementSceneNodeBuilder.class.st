Class {
	#name : #WDELevelEditorElementSceneNodeBuilder,
	#superclass : #WDELevelVisitor,
	#instVars : [
		'editorSceneModel'
	],
	#category : #'WodenEngine-Editor-UI'
}

{ #category : #'as yet unclassified' }
WDELevelEditorElementSceneNodeBuilder >> createDirectionalLightVisualizationNodeFor: lightComponent [
	| node |
	node := WDSGSpatialObject new.
	node renderable: (self engine resourceCache flatShadedUnitCubeMesh copy
		isOpaqueShadowCaster: false;
		yourself).
	node
		color: self lightSourceDisplayMeshColor;
		transform: (BoxF32 halfExtent: 0.1) reversibleTransformToConvertUnitBoxToMe.
	^ node
]

{ #category : #'as yet unclassified' }
WDELevelEditorElementSceneNodeBuilder >> createPointLightVisualizationNodeFor: component [
	| node |
	node := WDSGSpatialObject new.
	node renderable: (self engine resourceCache flatShadedUnitDiameterSphere copy 
			isOpaqueShadowCaster: false;
			yourself).
	node
		color: self lightSourceDisplayMeshColor;
		transform: (BoxF32 halfExtent: 0.1) reversibleTransformToConvertUnitBoxToMe.
	^ node
]

{ #category : #'as yet unclassified' }
WDELevelEditorElementSceneNodeBuilder >> createSpotLightVisualizationNodeFor: lightComponent [
	| node |
	node := WDSGSpatialObject new.
	node renderable: (self engine resourceCache flatShadedUnitDiameterZConeMesh copy
		isOpaqueShadowCaster: false;
		yourself).
	node
		color: self lightSourceDisplayMeshColor;
		transform: (BoxF32 halfExtent: 0.1) reversibleTransformToConvertUnitBoxToMe.
	^ node
]

{ #category : #accessing }
WDELevelEditorElementSceneNodeBuilder >> editorSceneModel [
	^ editorSceneModel
]

{ #category : #accessing }
WDELevelEditorElementSceneNodeBuilder >> editorSceneModel: anObject [
	editorSceneModel := anObject
]

{ #category : #accessing }
WDELevelEditorElementSceneNodeBuilder >> engine [
	^ editorSceneModel engine
]

{ #category : #'as yet unclassified' }
WDELevelEditorElementSceneNodeBuilder >> lightSourceDisplayMeshColor [
	^ Color yellow darker muchLighter
]

{ #category : #'visual components' }
WDELevelEditorElementSceneNodeBuilder >> setLightSource: node stateFromComponent: component [
	node
		intensity: (Float32x4 xyz: component intensity w: 1.0);
		castShadows: component castShadows;
		radius: component radius.
	component isSpotLightSourceVisualComponent ifTrue: [
		node
			innerSpotCutoff: component innerCutOffAngle;
			outerSpotCutoff: component outerCutOffAngle
	]
]

{ #category : #'collision components' }
WDELevelEditorElementSceneNodeBuilder >> visitBoxCollisionComponent: component [
	^ nil
]

{ #category : #'visual components' }
WDELevelEditorElementSceneNodeBuilder >> visitBoxVisualComponent: component [
	| node |
	node := WDSGSpatialObject new.
	node renderable: self engine resourceCache unitCubeMesh.
	node
		color: component color;
		transform: component boundingBox reversibleTransformToConvertUnitBoxToMe.
	component whenChangedDo: [
		node
			color: component color;
			transform: component boundingBox reversibleTransformToConvertUnitBoxToMe
	].
	^ node
]

{ #category : #visiting }
WDELevelEditorElementSceneNodeBuilder >> visitDirectionalLightSourceVisualComponent: component [
	^ (super visitDirectionalLightSourceVisualComponent: component)
		directional;
		addChild: (self createDirectionalLightVisualizationNodeFor: component);
		yourself
]

{ #category : #visiting }
WDELevelEditorElementSceneNodeBuilder >> visitEntity: entity [
	| node |
	node := WDSGSpatialObject new.
	node transform: entity transform.
	entity whenTransformChangedDo: [ :newTransform | node transform: newTransform ].

	editorSceneModel mapLevelElement: entity toSceneNode: node.
	entity components do: [ :each |
		(self visitLevelElement: each) ifNotNil: [:childNode |
			node addChild: childNode
		].
	].

	editorSceneModel createEntityEditorSelectionBoxNode: entity.
	^ node
]

{ #category : #'visual components' }
WDELevelEditorElementSceneNodeBuilder >> visitLightSourceVisualComponent: component [
	| node |
	node := WDSGLightSource new.
	self setLightSource: node stateFromComponent: component.
	component whenChangedDo: [
		self setLightSource: node stateFromComponent: component.
	].
	^ node
]

{ #category : #visiting }
WDELevelEditorElementSceneNodeBuilder >> visitPointLightSourceVisualComponent: component [
	^ (super visitPointLightSourceVisualComponent: component)
		point;
		addChild: (self createPointLightVisualizationNodeFor: component);
		yourself
]

{ #category : #'collision components' }
WDELevelEditorElementSceneNodeBuilder >> visitRectangleCollisionComponent: component [
	^ self visitBoxCollisionComponent: component
]

{ #category : #'visual components' }
WDELevelEditorElementSceneNodeBuilder >> visitRectangleVisualComponent: component [
	^ self visitBoxVisualComponent: component
]

{ #category : #visiting }
WDELevelEditorElementSceneNodeBuilder >> visitSector: sector [
	| node |
	node := WDSGSpatialObject new.
	editorSceneModel mapLevelElement: sector toSceneNode: node.
	sector layers do: [ :each |
		(self visitLevelElement: each) ifNotNil: [:childNode |
			node addChild: childNode
		].
	].
	^ node
]

{ #category : #visiting }
WDELevelEditorElementSceneNodeBuilder >> visitSectorLayer: sectorLayer [
	| node |
	node := WDSGSpatialObject new.
	editorSceneModel mapLevelElement: sectorLayer toSceneNode: node.
	sectorLayer entities do: [ :each |
		(self visitLevelElement: each) ifNotNil: [:childNode |
			node addChild: childNode
		].
	].
	^ node
]

{ #category : #visiting }
WDELevelEditorElementSceneNodeBuilder >> visitSpotLightSourceVisualComponent: component [
	^ (super visitSpotLightSourceVisualComponent: component)
		spot;
		addChild: (self createSpotLightVisualizationNodeFor: component);
		yourself
]
