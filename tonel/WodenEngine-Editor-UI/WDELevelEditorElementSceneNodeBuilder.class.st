Class {
	#name : #WDELevelEditorElementSceneNodeBuilder,
	#superclass : #WDELevelVisitor,
	#instVars : [
		'editorSceneModel',
		'editorColorMaterials'
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
		transform: (BoxF32 halfExtent: WDEEntity pointEntitySelectionBoxHalfExtent) reversibleTransformToConvertUnitBoxToMe.
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
		transform: (BoxF32 halfExtent: WDEEntity pointEntitySelectionBoxHalfExtent) reversibleTransformToConvertUnitBoxToMe.
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
		transform: (BoxF32 halfExtent: WDEEntity pointEntitySelectionBoxHalfExtent) reversibleTransformToConvertUnitBoxToMe.
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

{ #category : #initialization }
WDELevelEditorElementSceneNodeBuilder >> initialize [
	super initialize.
	editorColorMaterials := Dictionary new.
]

{ #category : #accessing }
WDELevelEditorElementSceneNodeBuilder >> levelEditorSession [
	^ editorSceneModel levelEditorSession
]

{ #category : #'as yet unclassified' }
WDELevelEditorElementSceneNodeBuilder >> lightSourceDisplayMeshColor [
	^ Color yellow darker muchLighter
]

{ #category : #'visual components' }
WDELevelEditorElementSceneNodeBuilder >> makeEditorColorMaterialFor: component [
	| color |
	color := component entity editorColor.
	^ editorColorMaterials at: color ifAbsentPut: [
		(WDCMetallicRoughnessMaterial for: self engine)
			baseColorFactor: color;
			yourself
	]
]

{ #category : #'visual components' }
WDELevelEditorElementSceneNodeBuilder >> setLightSource: node stateFromComponent: component [
	node
		intensity: (Float32x4 xyz: component coloredIntensity w: 0.0);
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
	^ self visitGeneratedMeshVisualComponent: component
]

{ #category : #'visual components' }
WDELevelEditorElementSceneNodeBuilder >> visitConvexPolygonVisualComponent: component [
	^ self visitGeneratedMeshVisualComponent: component
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
	entity whenVisibleInEditorChanged: [ :value | node visible: value ].
	entity components do: [ :each |
		(self visitLevelElement: each) ifNotNil: [:childNode |
			node addChild: childNode
		].
	].

	editorSceneModel createEntityEditorSelectionBoxNode: entity.
	^ node
]

{ #category : #'visual components' }
WDELevelEditorElementSceneNodeBuilder >> visitFileReferenceModel: component [
	| node oldNode |
	node := WDSGSpatialObject new.
	oldNode := nil.
	component whenChangedDoNow: [
		| newNode|
		newNode := component getOrCreateModelNodeFor: self engine levelEditorSession: self levelEditorSession.
		oldNode ifNotNil: [ oldNode removeFromParent ].
		newNode ifNotNil: [ 
			node addChild: newNode.
		].
		oldNode := newNode.
	].

	^ node
]

{ #category : #'visual components' }
WDELevelEditorElementSceneNodeBuilder >> visitGeneratedMeshVisualComponent: component [
	| node |
	node := WDSGSpatialObject new.
	component whenChangedDoNow: [
		| renderable editorColorMaterial wireMesh solidMesh |
		renderable := WDERenderableWithEditorAlternatives new.
		editorColorMaterial := self makeEditorColorMaterialFor: component.

		wireMesh := component buildWireMeshWith: (WDCComplexGenericMeshBuilder for: self engine) material: editorColorMaterial.
		solidMesh := component buildSolidMeshWith: (WDCComplexGenericMeshBuilder for: self engine) levelEditorSession: self levelEditorSession modelTransform: component entity transform.

		renderable
			wireFrameRenderable: wireMesh;
			colorRenderable: (solidMesh copy setMaterial: editorColorMaterial);
			shadedRenderable: solidMesh.

		node
			renderable: renderable;
			stateChanged
	].
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
WDELevelEditorElementSceneNodeBuilder >> visitPolygonConvexHullCollisionComponent: component [
	^ nil
]

{ #category : #visiting }
WDELevelEditorElementSceneNodeBuilder >> visitPolygonSideAttributes: polyhedronFace [
	^ nil
]

{ #category : #'collision components' }
WDELevelEditorElementSceneNodeBuilder >> visitPolyhedronConvexHullCollisionComponent: component [
	^ nil
]

{ #category : #visiting }
WDELevelEditorElementSceneNodeBuilder >> visitPolyhedronFace: polyhedronFace [
	^ nil
]

{ #category : #'visual components' }
WDELevelEditorElementSceneNodeBuilder >> visitPolyhedronVisualComponent: component [
	^ self visitGeneratedMeshVisualComponent: component
]

{ #category : #'collision components' }
WDELevelEditorElementSceneNodeBuilder >> visitRectangleCollisionComponent: component [
	^ self visitBoxCollisionComponent: component
]

{ #category : #'visual components' }
WDELevelEditorElementSceneNodeBuilder >> visitRectangleVisualComponent: component [
	^ self visitGeneratedMeshVisualComponent: component
]

{ #category : #visiting }
WDELevelEditorElementSceneNodeBuilder >> visitSector: sector [
	| node |
	node := WDSGSpatialObject new.
	editorSceneModel mapLevelElement: sector toSceneNode: node.
	sector whenVisibleInEditorChanged: [ :value | node visible: value ].
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
	sectorLayer whenVisibleInEditorChanged: [ :value | node visible: value ].
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
