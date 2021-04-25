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
		'axisMesh',
		'baseGridSize',
		'highlightedManipulator',
		'activeToolManipulator',
		'levelSceneNodeBuilder'
	],
	#category : #'WodenEngine-Editor-UI'
}

{ #category : #'main actions' }
WDELevelEditorSceneModel >> actionOpenFile [
	| dialog result |
	dialog := self createLevelFileDialog.
	dialog title: 'Select the level to open'; answerPathName.
	result := dialog openModal answer.
	result ifNil: [ ^ self ].
	levelEditorSession openFrom: result asFileReference
]

{ #category : #'main actions' }
WDELevelEditorSceneModel >> actionSaveFile [
	levelEditorSession levelFileReference ifNotNil: [ :fileReference |
		levelEditorSession saveTo: fileReference
	] ifNil: [
		self actionSaveFileAs
	]
]

{ #category : #'main actions' }
WDELevelEditorSceneModel >> actionSaveFileAs [
	| dialog result |
	dialog := self createLevelFileDialog.
	dialog
		title: 'Select the location to save the level';
		fileNameText: 'level.wtlevel';
		answerSaveFile.
	levelEditorSession levelFileReference ifNotNil: [ :fileRef |
		dialog
			fileNameText: fileRef basename;
			selectPath: fileRef parent
	].

	result := dialog openModal answer.
	result ifNil: [ ^ self ].
	levelEditorSession saveTo: result asFileReference
]

{ #category : #'editor modes' }
WDELevelEditorSceneModel >> activateObjectMode [
	views do: [ :v | v activateObjectMode ]
]

{ #category : #'ray casting' }
WDELevelEditorSceneModel >> activeManipulatorsDo: aBlock [
	activeToolManipulator ifNotNil: [ aBlock value: activeToolManipulator ].
]

{ #category : #accessing }
WDELevelEditorSceneModel >> activeToolManipulator [
	^ activeToolManipulator
]

{ #category : #accessing }
WDELevelEditorSceneModel >> activeToolManipulator: newManipulator [
	activeToolManipulator ifNotNil: [
		activeToolManipulator removeFromScene.
		activeToolManipulator := nil.
	].

	activeToolManipulator := newManipulator.
	activeToolManipulator ifNotNil: [
		activeToolManipulator addToScene: scene.
		self highlightManipulator: nil; highlightElement: nil.
		views ifNotEmpty: [ activeToolManipulator updateForViewCamera: views first ]
	].
]

{ #category : #accessing }
WDELevelEditorSceneModel >> addElementToScene: element [
	| elementNode |
	(levelElementToSceneNodeDictionary includesKey: element) ifTrue: [ ^ self ].

	elementNode := self levelSceneNodeBuilder
		visitLevelElement: element.
	elementNode ifNil: [ ^ self ].
	element isSector ifTrue: [
		scene add: elementNode
	] ifFalse: [
		self assert: element parent isNotNil.
		levelElementToSceneNodeDictionary at: element parent ifPresent: [ :parentNode |
			parentNode addChild: elementNode
		]
	]
]

{ #category : #adding }
WDELevelEditorSceneModel >> addView: aView [
	super addView: aView.
	views size = 1 ifTrue: [ self initialCameraSetupForView: aView ].
]

{ #category : #accessing }
WDELevelEditorSceneModel >> applyNewSelection: newSelection [
	| selectedEntities |
	self activeToolManipulator: nil.
	selectedEntities := newSelection selectedItems select: [ :each | each isEntity ].
	selectedEntities ifNotEmpty: [
		self activeToolManipulator: ((WDELevelEditor3DSelectionManipulator for: self)
			selectedElements: selectedEntities;
			yourself)
	].

]

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

{ #category : #accessing }
WDELevelEditorSceneModel >> baseGridSize [
	^ baseGridSize
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
	selectionBoxNode
		renderable: self entitySelectionBoxRenderable.
	entity whenEditorColorChangedDoNow: [
		selectionBoxNode
			color: entity editorColor
	].
	entityNode addChild: selectionBoxNode.
	levelElementToSelectionBoxNode at: entity put: selectionBoxNode.
	selectionBoxNode transform:
		entity localSelectableBoundingBox reversibleTransformToConvertUnitBoxToMe.
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
		renderable: (engine resourceCache flatShadedTranslucentUnitCubeMesh copy 			setFlatColorSubRenderMode; 
			isOpaqueShadowCaster: false;
			yourself);
		visible: false;
		yourself.
	scene add: highlightBoxNode.
]

{ #category : #'main actions' }
WDELevelEditorSceneModel >> createLevelFileDialog [
	^ FileDialogWindow basicNew
		initialize;
		validExtensions: #(wtlevel wlevel);
		yourself
]

{ #category : #'instance creation' }
WDELevelEditorSceneModel >> createSubGridNode [
	subGridNode := WDSGSpatialObject new.
	subGridNode
		renderable: self subGridMesh;
		color: Color darkGray darker.
	scene add: subGridNode
]

{ #category : #'ray casting' }
WDELevelEditorSceneModel >> elementsInFrustum: frustum [
	^ self level elementsInFrustum: frustum
]

{ #category : #accessing }
WDELevelEditorSceneModel >> entitySelectionBoxRenderable [
	^ entitySelectionBoxRenderable ifNil: [
		entitySelectionBoxRenderable := engine resourceCache flatShadedUnitCubeMesh copy
			setFlatColorSubRenderMode; 
			isOpaqueShadowCaster: false;
			yourself
		]
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

{ #category : #snapping }
WDELevelEditorSceneModel >> gridSize [
	^ levelEditorSession gridSize
]

{ #category : #'as yet unclassified' }
WDELevelEditorSceneModel >> highlightElement: anElement [
	anElement ifNil: [
		highlightBoxNode visible: false.
	] ifNotNil: [
		highlightBoxNode
			visible: true;
			color: WDELevelEditorTheme current highlightColor;
			transform: (anElement selectableBoundingBox withExpandedHalfExtent: 0.025) reversibleTransformToConvertUnitBoxToMe.
	]
]

{ #category : #'as yet unclassified' }
WDELevelEditorSceneModel >> highlightManipulator: aManipulator [
	highlightedManipulator ifNotNil: [ highlightedManipulator highlighted: false ].
	highlightedManipulator := aManipulator.
	highlightedManipulator ifNotNil: [ highlightedManipulator highlighted: true ].
]

{ #category : #adding }
WDELevelEditorSceneModel >> initialCameraSetupForView: aView [
	camera position: (Float32x3 z: aView cameraFocalPointDistance).
	aView frontView.

]

{ #category : #initialization }
WDELevelEditorSceneModel >> initializeModel [
	baseGridSize := 10.0.
]

{ #category : #testing }
WDELevelEditorSceneModel >> isAnimated [
	^ false
]

{ #category : #accessing }
WDELevelEditorSceneModel >> level [
	^ levelEditorSession level
]

{ #category : #accessing }
WDELevelEditorSceneModel >> levelChanged [
	self newScene.
	levelElementToSceneNodeDictionary := IdentityDictionary new.
	levelElementToSelectionBoxNode := IdentityDictionary new.
	self level sectors do: [ :each |
		self addElementToScene: each
		].
	self level
		whenAddedElementDo: [ :element |
			self addElementToScene: element
		];
		whenRemovedElementDo: [ :element |
			self removeElementFromScene: element
		]
]

{ #category : #accessing }
WDELevelEditorSceneModel >> levelEditorSession [
	^ levelEditorSession
]

{ #category : #accessing }
WDELevelEditorSceneModel >> levelEditorSession: anObject [
	levelEditorSession := anObject.
	
	levelEditorSession
		whenActiveLevelElementTemplateDo: [ :template | views do: [ :v | v levelElementTemplateSelected: template ] ];
		whenLevelChangedDo: [ self levelChanged ];
		whenSelectionChangedDo: [ :newSelection | self applyNewSelection: newSelection ];
		whenStartingToPlaceDuplicatedItemsDo: [ :duplicatedItems :oldSelection |
			self startPlacingDuplicatedElements: duplicatedItems oldSelection: oldSelection
		].
	self levelChanged.
]

{ #category : #accessing }
WDELevelEditorSceneModel >> levelSceneNodeBuilder [
	^ levelSceneNodeBuilder ifNil: [levelSceneNodeBuilder := WDELevelEditorElementSceneNodeBuilder new editorSceneModel: self]
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
		hasAutoExposure: false.
	views ifNotEmpty: [
		self initialCameraSetupForView: views first
	].
	views do: [ :each | each cameraChanged ].
		
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

{ #category : #'ray casting' }
WDELevelEditorSceneModel >> rayCastAllAlong: ray [
	^ self level rayCastAllAlong: ray
]

{ #category : #'ray casting' }
WDELevelEditorSceneModel >> rayCastForManipulator: ray [
	| bestResult |
	bestResult := nil.
	self activeManipulatorsDo: [ :each |
		(each rayCast: ray) ifNotNil: [ :result |
			(bestResult isNil or: [ result < bestResult ]) ifTrue: [ 
				bestResult := result
			]
		].
	].

	^ bestResult value
]

{ #category : #accessing }
WDELevelEditorSceneModel >> removeElementFromScene: element [
	self changed.
	levelElementToSelectionBoxNode at: element ifPresent: [ :node |
		node removeFromScene.
		levelElementToSelectionBoxNode removeKey: element
	].

	levelElementToSceneNodeDictionary at: element ifPresent: [ :node |
		node removeFromScene.
		levelElementToSceneNodeDictionary removeKey: element
	].
]

{ #category : #utiltity }
WDELevelEditorSceneModel >> roundFloor: value quantum: quantum [
	^ levelEditorSession roundFloor: value quantum: quantum
]

{ #category : #snapping }
WDELevelEditorSceneModel >> roundToGrid: value [
	| quantum |
	quantum := self secondaryGridSize.
	^ ((value / quantum) + 0.5) floor * quantum
]

{ #category : #snapping }
WDELevelEditorSceneModel >> snapToGrid: vector [
	^ levelEditorSession snapToGrid: vector
]

{ #category : #snapping }
WDELevelEditorSceneModel >> snapToSubGrid: vector [
	^ levelEditorSession snapToSubGrid: vector
]

{ #category : #accessing }
WDELevelEditorSceneModel >> startPlacingDuplicatedElements: duplicatedItems oldSelection: oldSelection [
	views first startPlacingDuplicatedElements: duplicatedItems oldSelection: oldSelection
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

{ #category : #snapping }
WDELevelEditorSceneModel >> subGridSize [
	^ levelEditorSession subGridSize 
]
