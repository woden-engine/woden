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
	| node |
	node := WDSGSpatialObject new.
	component whenChangedDoNow: [
		| renderable editorColorMaterial material wireMesh solidMesh transform parentTransform |
		renderable := WDERenderableWithEditorAlternatives new.
		material := (component material
			ifNotNil: [ :mat | mat asRenderingMaterialForSession: self levelEditorSession engine: self engine ]
			ifNil: [self engine resourceCache defaultMaterial]).
		editorColorMaterial := self makeEditorColorMaterialFor: component.
		transform := component boundingBox reversibleTransformToConvertUnitBoxToMe.
		parentTransform := component entity transform.

		wireMesh :=
			(WDCComplexGenericMeshBuilder for: self engine)
				currentMaterial: editorColorMaterial;
				transform: transform;
				addWireCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
				computeBoundingBox;
				mesh.
			
		solidMesh :=
			(WDCComplexGenericMeshBuilder for: self engine)
				transform: transform;
				currentMaterial: material;
				addCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
				planeTextureScale: component textureScale offset: component textureOffset withModelTransform: parentTransform;
				computeTangentsBitangents;
				computeBoundingBox;
				mesh.

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
