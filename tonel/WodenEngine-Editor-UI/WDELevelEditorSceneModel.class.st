Class {
	#name : #WDELevelEditorSceneModel,
	#superclass : #WDASceneModel,
	#instVars : [
		'levelEditorSession',
		'levelElementToSceneNodeDictionary',
		'levelElementToSelectionBoxNode',
		'highlightBoxNode',
		'entitySelectionBoxRenderable',
		'gridNode',
		'subGridNode',
		'gridMaterial',
		'gridMesh',
		'subGridMesh',
		'axisNode',
		'axisMesh'
	],
	#category : #'WodenEngine-Editor-UI'
}

{ #category : #'instance creation' }
WDELevelEditorSceneModel >> axisMesh [
	^ axisMesh ifNil: [
		| start end |
		start := -10000.0.
		end := start negated. 

		axisMesh := ((WDCGenericMeshBuilder for: engine)
			currentMaterial: self gridMaterial;
			beginLines;
			color: Color red;
			addP: (Float32x3 x: start y: 0.0 z: 0.0);
			addP: (Float32x3 x: end y: 0.0 z: 0.0);
			color: Color green;
			addP: (Float32x3 x: 0.0 y: start z: 0.0);
			addP: (Float32x3 x: 0.0 y: end z: 0.0);
			color: Color blue;
			addP: (Float32x3 x: 0.0 y: 0.0 z: start);
			addP: (Float32x3 x: 0.0 y: 0.0 z: end);
			addI1: 1 i2: 2;
			addI1: 3 i2: 4;
			addI1: 5 i2: 6;
			mesh)
				setFlatColorSubRenderMode;
				depthWriteMask: false;
				yourself
	]
]

{ #category : #accessing }
WDELevelEditorSceneModel >> axisNode [
	^ axisNode
]

{ #category : #'instance creation' }
WDELevelEditorSceneModel >> createAxisNode [
	axisNode := WDSGSpatialObject new.
	axisNode
		renderable: self axisMesh.
	scene add: axisNode
]

{ #category : #accessing }
WDELevelEditorSceneModel >> createEntityEditorSelectionBoxNode: entity [
	| entityNode selectionBoxNode |
	(levelElementToSelectionBoxNode includesKey: entity) ifTrue: [ ^ self ].
	entityNode := self nodeForLevelElement: entity.
	entityNode children isNotEmpty ifTrue: [ ^ self ].

	selectionBoxNode := WDSGSpatialObject new.
	selectionBoxNode renderable: self entitySelectionBoxRenderable.
	entityNode addChild: selectionBoxNode.
	levelElementToSelectionBoxNode at: entity put: selectionBoxNode.
	selectionBoxNode transform: entity localSelectableBoundingBox reversibleTransformToConvertUnitBoxToMe.
]

{ #category : #'instance creation' }
WDELevelEditorSceneModel >> createGridNode [
	gridNode := WDSGSpatialObject new.
	gridNode
		renderable: self gridMesh;
		color: Color gray lighter.
	scene add: gridNode
]

{ #category : #'instance creation' }
WDELevelEditorSceneModel >> createHighlightBoxNode [
	highlightBoxNode := WDSGSpatialObject new
		renderable: engine resourceCache flatShadedTranslucentUnitCubeMesh copy setFlatColorSubRenderMode;
		color: (Float32x4 x: 0.3 y: 0.3 z: 0.9 w: 0.5);
		visible: false;
		yourself.
	scene add: highlightBoxNode.
]

{ #category : #'instance creation' }
WDELevelEditorSceneModel >> createSubGridNode [
	subGridNode := WDSGSpatialObject new.
	subGridNode
		renderable: self subGridMesh;
		color: Color darkGray darker.
	scene add: subGridNode
]

{ #category : #accessing }
WDELevelEditorSceneModel >> entitySelectionBoxRenderable [
	^ entitySelectionBoxRenderable ifNil: [ entitySelectionBoxRenderable := engine resourceCache flatShadedUnitCubeMesh copy setFlatColorSubRenderMode; yourself ]
]

{ #category : #accessing }
WDELevelEditorSceneModel >> gridMaterial [
	^ gridMaterial ifNil: [ gridMaterial := engine resourceCache whiteFlatColorMaterial ]
]

{ #category : #'instance creation' }
WDELevelEditorSceneModel >> gridMesh [
	^ gridMesh ifNil: [gridMesh := ((WDCGenericMeshBuilder for: engine)
		currentMaterial: self gridMaterial;
		addLineGridWithWidth: 200 height: 200 subdivisions: 21;
		mesh)
			setFlatColorSubRenderMode;
			depthWriteMask: false;
			yourself
	]
]

{ #category : #accessing }
WDELevelEditorSceneModel >> gridNode [
	^ gridNode
]

{ #category : #'as yet unclassified' }
WDELevelEditorSceneModel >> highlightElement: anElement [
	anElement ifNil: [
		highlightBoxNode visible: false.
	] ifNotNil: [
		highlightBoxNode
			visible: true;
			transform: (anElement selectableBoundingBox withExpandedHalfExtent: 0.025) reversibleTransformToConvertUnitBoxToMe.
	]
]

{ #category : #initialization }
WDELevelEditorSceneModel >> initializeModel [
]

{ #category : #accessing }
WDELevelEditorSceneModel >> level [
	^ levelEditorSession level
]

{ #category : #accessing }
WDELevelEditorSceneModel >> levelChanged [
	| builder |
	self newScene.
	levelElementToSceneNodeDictionary := IdentityDictionary new.
	levelElementToSelectionBoxNode := IdentityDictionary new.
	builder := WDELevelEditorElementSceneNodeBuilder new editorSceneModel: self.
	self level sectors do: [ :each |
		scene add: (builder visitLevelElement: each)
	].
]

{ #category : #accessing }
WDELevelEditorSceneModel >> levelEditorSession [
	^ levelEditorSession
]

{ #category : #accessing }
WDELevelEditorSceneModel >> levelEditorSession: anObject [
	levelEditorSession := anObject.
	
	levelEditorSession whenLevelChangedDo: [ self levelChanged ].
	self levelChanged.
]

{ #category : #accessing }
WDELevelEditorSceneModel >> mapLevelElement: levelElement toSceneNode: sceneNode [
	levelElementToSceneNodeDictionary at: levelElement put: sceneNode
]

{ #category : #'instance creation' }
WDELevelEditorSceneModel >> newScene [
	super newScene.
	scene backgroundColor: (Float32x4 xyz: (0.015 implicitCastTo: Float32x3) w: 1.0).
	camera
		hasAutoExposure: false;
		translateByX: 0 y: 3 z: 10.
		
	self
		createHighlightBoxNode;
		createAxisNode;
		createGridNode;
		createSubGridNode.
	^ scene
]

{ #category : #accessing }
WDELevelEditorSceneModel >> nodeForLevelElement: levelElement [
	^ levelElementToSceneNodeDictionary at: levelElement
]

{ #category : #'ray casting' }
WDELevelEditorSceneModel >> rayCast: ray [
	^ self level rayCast: ray
]

{ #category : #'instance creation' }
WDELevelEditorSceneModel >> subGridMesh [
	^ subGridMesh ifNil: [subGridMesh := ((WDCGenericMeshBuilder for: engine)
		currentMaterial: self gridMaterial;
		addLineGridWithWidth: 200 height: 200 subdivisions: 201;
		mesh)
			setFlatColorSubRenderMode;
			depthWriteMask: false;
			yourself
	]
]

{ #category : #accessing }
WDELevelEditorSceneModel >> subGridNode [
	^ subGridNode
]
