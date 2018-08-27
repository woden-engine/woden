Class {
	#name : #WTGLevelEditor,
	#superclass : #WDASceneModel,
	#instVars : [
		'sceneRenderer',
		'map',
		'mapFileName',
		'renderMode',
		'levelViews',
		'selectionBox',
		'primaryGridMesh',
		'secondaryGridMesh',
		'centerAxisMesh',
		'currentMaterialName',
		'materialThumbDB',
		'thumbnailPaintCache',
		'selection',
		'faceSelectMode',
		'currentInspector',
		'textureTransformEditor',
		'gridSize'
	],
	#classVars : [
		'DefaultSettingsForViews',
		'MaterialThumbDBFileName'
	],
	#category : #'WodenEngine-LevelEditor-Old'
}

{ #category : #'as yet unclassified' }
WTGLevelEditor class >> initialize [
	super initialize.
	
	MaterialThumbDBFileName := 'WTGLevelEditor_MaterialThumb.db'.
	
	DefaultSettingsForViews := {
		"Top Left"
		[ :view | view orthographic; wireframe; topView ].
	
		"Top Right"
		[ :view |
			view perspective; solid; frontView. 
			view cameraTransform translateByZ: 3.0; translateByY: 1.0.
		].
		
		"Bottom Left"
		[ :view | view orthographic; wireframe; frontView ].
		
		"Bottom Right"
		[ :view | view orthographic; wireframe; sideView ].
	}
]

{ #category : #actions }
WTGLevelEditor >> addCubeBrushAtSelectionCube [
	| brush |
	(selectionBox isEmpty or: [ selectionBox isSpaceSelection not ]) ifTrue: [ ^ self ].
	
	brush := WDGSBrush box: selectionBox box.
	brush material: currentMaterialName.
	map entities first addComponent: brush.
	
	selectionBox addElement: brush.
]

{ #category : #actions }
WTGLevelEditor >> addGunItem: aPosition [
	(self addPointEntity: aPosition) addBehaviorClass: WDGSMagnumItemBehavior.
]

{ #category : #actions }
WTGLevelEditor >> addLightEntity: aPosition [
	| entity |
	entity := WDGSEntity new.
	entity
		addComponent: WDGSSpatialDescription new lookDown;
		addComponent: WDGSLightSourceComponent new.
	entity spatialDescription translation: aPosition.
	map addEntity: entity.
]

{ #category : #actions }
WTGLevelEditor >> addModel: modelName [
	self addModel: modelName position: WMVector3D new.
]

{ #category : #actions }
WTGLevelEditor >> addModel: modelName position: aPosition [
	| entity model |
	model := engine resourceCache loadModel: modelName.
	entity := WDGSEntity new.
	entity
		addComponent: WDGSSpatialDescription new;
		addComponent: (WDGSModel new modelName: modelName).
	entity spatialDescription
		localBoundingBox: model boundingBox asWMBox3DD;
		translation: aPosition.
	map addEntity: entity.
	^ entity
]

{ #category : #actions }
WTGLevelEditor >> addPlayerSpawnPoint: aPosition [
	| entity |
	entity := WDGSEntity new.
	entity
		addComponent: WDGSSpatialDescription new;
		addComponent: (WDGSBehaviorClass new behaviorClassName: WDGSPlayerSpawnPointBehavior name).
	entity spatialDescription
		translation: aPosition;
		localBoundingBox: (WMBox3DD halfExtent: WDGSPlayerBehavior halfExtent).
	map addEntity: entity.
]

{ #category : #actions }
WTGLevelEditor >> addPointEntity: aPosition [
	| entity |
	entity := WDGSEntity new.
	entity
		addComponent: WDGSSpatialDescription new.
	entity spatialDescription translation: aPosition.
	map addEntity: entity.
	^ entity
]

{ #category : #actions }
WTGLevelEditor >> applyCurrentMaterialToSelection [
	self flag: 'Add a memento or something for undo/redo'.
	selection elements do: [ :element | element material: currentMaterialName ]
]

{ #category : #accessing }
WTGLevelEditor >> centerAxisMesh [
	| start end |
	centerAxisMesh ifNotNil: [ ^ centerAxisMesh ].
	start := -10000.0.
	end := start negated. 
	
	centerAxisMesh := (WDCGenericMeshBuilder for: engine)
		material: self gridMaterial;
		beginLines;
		color: Color red;
		addP: (WMVector3F x: start y: 0.0 z: 0.0);
		addP: (WMVector3F x: end y: 0.0 z: 0.0);
		color: Color green;
		addP: (WMVector3F x: 0.0 y: start z: 0.0);
		addP: (WMVector3F x: 0.0 y: end z: 0.0);
		color: Color blue;
		addP: (WMVector3F x: 0.0 y: 0.0 z: start);
		addP: (WMVector3F x: 0.0 y: 0.0 z: end);
		addI1: 1 i2: 2;
		addI1: 3 i2: 4;
		addI1: 5 i2: 6;
		mesh.
	^ centerAxisMesh
]

{ #category : #accessing }
WTGLevelEditor >> centerAxisMesh: anObject [
	centerAxisMesh := anObject
]

{ #category : #initialization }
WTGLevelEditor >> clearScene [
	scene := WDSGScene for: engine.
	scene backgroundColor: Color veryDarkGray.

	self
		createSelectionBox.
		
	levelViews doWithIndex: [ :view :index |
		view sceneCreated.
		(DefaultSettingsForViews at: index) value: view.
	].
]

{ #category : #selection }
WTGLevelEditor >> clearSelection [
	faceSelectMode
		ifTrue: [ self selection: WDGSLevelEditorSelection new. ]
		ifFalse: [ self selection: WDGSLevelEditorSelectionBox empty. ]
	
]

{ #category : #rendering }
WTGLevelEditor >> createLeftToolPane [
	^ BlElement new
]

{ #category : #rendering }
WTGLevelEditor >> createLevelViews [
	| topLeft topRight bottomLeft bottomRight topHorizontalPane bottomHorizontalPane |
	topLeft := WTGLevelEditorView for: self.
	topRight := WTGLevelEditorView for: self.
	bottomLeft := WTGLevelEditorView for: self.
	bottomRight := WTGLevelEditorView for: self.
	levelViews := { topLeft . topRight . bottomLeft . bottomRight }.
	
	levelViews do: [ :view |
		view
			constraintsDo:[:c| c vhMatchParent ; alignCenter];
			background: Color transparent.
	].
				
	topHorizontalPane := BrHBoxPane new
		background: Color transparent;
		constraintsDo:[:c| c vhMatchParent ; alignCenter];
		addChildren:{topLeft . topRight}.
		
	bottomHorizontalPane := BrHBoxPane new
		background: Color transparent;
		constraintsDo:[:c| c vhMatchParent ; alignCenter];
		addChildren:{bottomLeft . bottomRight}.

	^ BrVBoxPane new
		background: Color transparent;
		constraintsDo:[:c| c vhMatchParent ; alignCenter; weight: 4];
		addChildren:{topHorizontalPane . bottomHorizontalPane}.
]

{ #category : #rendering }
WTGLevelEditor >> createMainBlocSpace [
	| space contentPane mainPane |
	
	BlMaterialTheme load.
	
	contentPane := BrHBoxPane new
		background: Color transparent;
		constraintsDo:[:c| c vhMatchParent ; alignCenter];
		addChildren:{"self createLeftToolPane . "self createLevelViews . self createRightToolPane}.

	mainPane := BrVBoxPane new
		background: Color transparent;
		constraintsDo:[:c| c vhMatchParent ; alignCenter];
		addChildren: { "self createMenuBar ." self createToolBar . contentPane . self createStatusBar }.
		
	space := BlSpace new.
	space hostWindow: (WTBlVirtualWindow new engine: engine).
	space root
		background: Color transparent;
		addChild: mainPane.
	
	^ space
	
]

{ #category : #initialization }
WTGLevelEditor >> createMap [
	| world |
	map := WDGSMap new.
	map editorMode: true.
	map scene: scene.
		
	world := WDGSEntity new.
	world worldEntity: true.
	map addEntity: world.
	
	renderMode := #solid.
]

{ #category : #rendering }
WTGLevelEditor >> createMenuBar [
	^ BlElement new
		constraintsDo:[:c| c hMatchParent ; alignCenter];
		background:(BlBackground fill: Color lightGray). 
]

{ #category : #rendering }
WTGLevelEditor >> createRightToolPane [
	| materialListView textureTransformView |
	textureTransformView := WTGLevelEditorTextureTransformView new.
	
	materialListView := WTGLevelEditorMaterialListView for: self.
	materialListView
		constraintsDo:[:c| c vhMatchParent ; alignCenter.].
	^ BrVBoxPane new
		background: Color gray;
		constraintsDo:[:c| c vhMatchParent ; alignCenter; weight: 1];
		addChildren: { "textureTransformView bloc . "materialListView}
]

{ #category : #initialization }
WTGLevelEditor >> createSelectionBox [
	self selection: WDGSLevelEditorSelectionBox empty.
]

{ #category : #rendering }
WTGLevelEditor >> createStatusBar [
	^ BlElement new 
		constraintsDo:[:c| c hMatchParent ; alignCenter];
		background:(BlBackground fill: Color lightGray). 
]

{ #category : #initialization }
WTGLevelEditor >> createThumbnailPaintCache [
	thumbnailPaintCache := WTAthensTexturePaintCache new engine: engine
]

{ #category : #rendering }
WTGLevelEditor >> createToolBar [
	| toolbar |
	toolbar := BrHBoxPane new
		constraintsDo:[:c| c hMatchParent; vFitContent; alignCenter];
		background:(BlBackground fill: Color lightGray).
	toolbar addChild: (self createToolbarButtonLabel: 'Open' action: [:evt | self open ]).
	toolbar addChild: (self createToolbarButtonLabel: 'Save' action: [:evt | self save ]).
	toolbar addChild: (self createToolbarButtonLabel: 'Save As' action: [:evt | self saveAs ]).
	toolbar addChild: (self createToolbarButtonLabel: 'Inspect' action: [:evt | self inspectSelection ]).
	toolbar addChild: (self createToolbarButtonLabel: 'Texture Transform' action: [:evt | self openTextureTransformEditor ]).
	toolbar addChild: (self createToolbarButtonLabel: 'Subtract' action: [:evt | self subtractSelectedBrushes ]).
	toolbar addChild: (self createToolbarButtonLabel: 'Make Brush Entity' action: [:evt | self makeBrushEntity ]).

	^ toolbar
]

{ #category : #rendering }
WTGLevelEditor >> createToolbarButtonLabel: label action: action [
	^ BrButton new
		text: label;
		margin:(BlInsets all:5);
		constraintsDo:[:c| c alignCenterLeft];
		addEventHandler: (BlOnClickHandler do: action)
]

{ #category : #accessing }
WTGLevelEditor >> currentMaterialName [
	^ currentMaterialName
]

{ #category : #accessing }
WTGLevelEditor >> currentMaterialName1: anObject [
	^ currentMaterialName := anObject
]

{ #category : #accessing }
WTGLevelEditor >> currentMaterialName: anObject [
	currentMaterialName := anObject.
	currentMaterialName ifNil: [ currentMaterialName := '' ]
]

{ #category : #accessing }
WTGLevelEditor >> defaultExtent [
	^ 1024@768
]

{ #category : #selection }
WTGLevelEditor >> elementsAlongRay: ray do: aBlock [
	| selectionMode |
	selectionMode := self isFaceSelectMode
		ifTrue: [ #face ]
		ifFalse: [ #entity"#brush" ].
	map elementsAlongRay: ray mode: selectionMode do: aBlock
]

{ #category : #accessing }
WTGLevelEditor >> faceSelectMode1: anObject [
	faceSelectMode := anObject
]

{ #category : #selection }
WTGLevelEditor >> faceSelectMode: mode [
	faceSelectMode := mode.
	faceSelectMode ifTrue: [
		self selection: selection asElementSelection
	] ifFalse: [
		self selection: selection asBoxSelection
	]
]

{ #category : #dialogs }
WTGLevelEditor >> fileOpenDialog: title extensions: extensions callback: callback [
	^ self fileOpenDialog: title extensions: extensions path: nil preview: nil callback: callback
]

{ #category : #dialogs }
WTGLevelEditor >> fileOpenDialog: title extensions: extensions path: path callback: callback [
	^ self fileOpenDialog: title extensions: extensions path: path preview: nil callback: callback
]

{ #category : #dialogs }
WTGLevelEditor >> fileOpenDialog: title extensions: extensions path: path preview: preview callback: callback [
	| dialog |
	dialog := FileDialogWindow new
		title: title;
		previewType: preview;
		initialize;
		title: title;
		answerPathName.
	extensions ifNotNil: [dialog validExtensions: extensions].
	path ifNotNil: [dialog selectPathName: path].
	dialog extent: 640@480;
		openInExternalWindowModalCallback: [ callback value: dialog answer ]
]

{ #category : #dialogs }
WTGLevelEditor >> fileSaveDialog: title extensions: extensions callback: callback [
	^ self fileSaveDialog: title initialAnswer: '' extensions: extensions path: nil callback: callback
]

{ #category : #dialogs }
WTGLevelEditor >> fileSaveDialog: title initialAnswer: fileName extensions: extensions callback: callback [
	^ self fileSaveDialog: title initialAnswer: fileName extensions: extensions path: nil callback: callback
]

{ #category : #dialogs }
WTGLevelEditor >> fileSaveDialog: title initialAnswer: fileName extensions: extensions path: path callback: callback [
	| dialog |
	dialog := FileDialogWindow new
		extent: 640@480;
		title: title;
		fileNameText: fileName;
		answerSaveFile.
	extensions ifNotNil: [dialog validExtensions: extensions].
	path ifNotNil: [dialog selectPathName: path].
	dialog openInExternalWindowModalCallback: [ callback value: dialog answer ]
]

{ #category : #accessing }
WTGLevelEditor >> gridMaterial [
	^ engine resourceCache loadMaterial: 'materials/basic/editor-grid.json'
]

{ #category : #inspector }
WTGLevelEditor >> gtInspectorItemsIn: composite [
	<gtInspectorPresentationOrder: 0> 
		^ (composite list)
			title: 'Selected elements';
			display: [ :aCollection | selection elements ]
]

{ #category : #initialization }
WTGLevelEditor >> initializeApplication [
	super initializeApplication.
	currentMaterialName := ''.
	faceSelectMode := false.
	gridSize := 1.0.
	self
		createThumbnailPaintCache;
		loadMaterialThumbDB;
		clearScene;
		createMap;
		initializeSceneRenderer.
]

{ #category : #initialization }
WTGLevelEditor >> initializeSceneRenderer [
	sceneRenderer := WTSForwardSceneRenderer for: engine.
	sceneRenderer scene: scene
]

{ #category : #actions }
WTGLevelEditor >> inspectSelection [
	currentInspector ifNotNil: [ ^ self ].
	currentInspector := GTInspector new.
	(currentInspector openInExternalWindowOn: self)
		extent: 640@480;
		closeCallback: [ currentInspector := nil ].
]

{ #category : #selection }
WTGLevelEditor >> isFaceSelectMode [
	^ faceSelectMode
]

{ #category : #actions }
WTGLevelEditor >> loadMapFromFileNamed: fileName [
	| newMap |
	newMap := WDGSMap loadJsonFromFileNamed: fileName.
	newMap editorMode: true.
	mapFileName := fileName.
	map ifNotNil: [ map scene: nil ].
	map := newMap.
	map scene: scene.
	
	renderMode := #solid.
]

{ #category : #initialization }
WTGLevelEditor >> loadMaterialThumbDB [
	materialThumbDB := WTResourceThumbnailDB tryToLoadFromFileNamed: MaterialThumbDBFileName.
	engine resourceCache ensureAllMaterialThumbnailsInDB: materialThumbDB.
	materialThumbDB saveTo: MaterialThumbDBFileName
]

{ #category : #actions }
WTGLevelEditor >> makeBrushEntity [
	| selectedBrushes |
	selectedBrushes := selection elements select: #isBrush.
	selectedBrushes ifEmpty: [ ^ self ].
	
	Transcript show: selectedBrushes; cr.
]

{ #category : #accessing }
WTGLevelEditor >> materialThumbDB [
	^ materialThumbDB
]

{ #category : #accessing }
WTGLevelEditor >> materialThumbDB: anObject [
	materialThumbDB := anObject
]

{ #category : #'mouse over' }
WTGLevelEditor >> mouseOverNone [
	self selectionBoxViewsDo: [ :view | view mouseOverIndex: -1 ].
]

{ #category : #actions }
WTGLevelEditor >> open [
	self fileOpenDialog: 'Open Level' extensions: #('json') callback: [ :fileName |
		fileName ifNotNil: [
			[ self loadMapFromFileNamed: fileName ] fork
		]
	] 
]

{ #category : #actions }
WTGLevelEditor >> openTextureTransformEditor [
	| textureTransformEditorWindow |
	textureTransformEditor ifNotNil: [ ^ self ].
	textureTransformEditor := WTGLevelEditorTextureTransformSpec new editor: self.
	self flag: 'Spec should provide a mechanism for this'.
	textureTransformEditorWindow := textureTransformEditor openExternalWindowWithSpec window value.
	textureTransformEditorWindow closeCallback: [ textureTransformEditor := nil ].
	textureTransformEditor selectionChanged.
	textureTransformEditorWindow changed
]

{ #category : #actions }
WTGLevelEditor >> playInExternalWindow [
	WDGSLevelPlayer new
		"initializeWithEngine: engine;"
		map: map playModeCopy;
		spawn;
		openInOSWindow.
]

{ #category : #accessing }
WTGLevelEditor >> primaryGridMesh [
	primaryGridMesh ifNotNil: [ ^ primaryGridMesh ].
	primaryGridMesh := (WDCGenericMeshBuilder for: engine)
		material: self gridMaterial;
		color: Color gray;
		addLineGridWithWidth: 200 height: 200 subdivisions: 21;
		mesh.
	^ primaryGridMesh
]

{ #category : #snapping }
WTGLevelEditor >> primaryGridSize [
	^ gridSize
]

{ #category : #'mouse capture' }
WTGLevelEditor >> releaseMouse [
	window ifNotNil: [ window releaseMouse ]
]

{ #category : #actions }
WTGLevelEditor >> removeSelectedComponents [
	selection elements do: [ :element | element removeFromMap ].
	self selection: WDGSLevelEditorSelectionBox empty
]

{ #category : #rendering }
WTGLevelEditor >> renderAboveBlocOnAthens: surface canvas: canvas [

]

{ #category : #rendering }
WTGLevelEditor >> renderContentOnWindow: aWindow frameIndex: frameIndex [
	self updateCommonRenderState.
	levelViews do: #updateCameraStateForRendering.
	sceneRenderer
		currentTime: currentTime + accumulatedUpdateTime;
		renderFrame: frameIndex viewports: (levelViews collect: #viewport) on: aWindow 
]

{ #category : #snapping }
WTGLevelEditor >> roundToGrid: value [
	| quantum |
	quantum := self secondaryGridSize.
	^ ((value / quantum) + 0.5) floor * quantum
]

{ #category : #actions }
WTGLevelEditor >> save [
	mapFileName ifNil: [ ^ self saveAs ].
	self saveMapToFileNamed: mapFileName.
	
]

{ #category : #actions }
WTGLevelEditor >> saveAs [
	self fileSaveDialog: 'Save Level' extensions: #('json') callback: [ :fileName |
		fileName ifNotNil: [
			[ self saveMapToFileNamed: fileName ] fork
		]
	] 
]

{ #category : #actions }
WTGLevelEditor >> saveMapToFileNamed: fileName [
	map saveJsonToFile: fileName.
	mapFileName := fileName.
]

{ #category : #accessing }
WTGLevelEditor >> scene [
	^ scene
]

{ #category : #accessing }
WTGLevelEditor >> secondaryGridMesh [
	secondaryGridMesh ifNotNil: [ ^ secondaryGridMesh ].
	secondaryGridMesh := (WDCGenericMeshBuilder for: engine)
		material: self gridMaterial;
		color: Color darkGray;
		addLineGridWithWidth: 200 height: 200 subdivisions: 201;
		mesh.
	^ secondaryGridMesh
]

{ #category : #snapping }
WTGLevelEditor >> secondaryGridSize [
	^ gridSize * 0.1
]

{ #category : #selection }
WTGLevelEditor >> selection [
	^ selection
]

{ #category : #selection }
WTGLevelEditor >> selection: aSelection [
	aSelection isSelectionBox ifTrue: [
		self useNewSelectionBox: aSelection.
	] ifFalse: [
		self useNewSelectionBox: WDGSLevelEditorSelectionBox empty.
		selection := aSelection.
		selection setSelectedState.
	].
	self selectionChanged.
]

{ #category : #selection }
WTGLevelEditor >> selectionBox [
	^ selectionBox
]

{ #category : #'mouse over' }
WTGLevelEditor >> selectionBoxMouseOver: boxIndex [
	self selectionBoxViewsDo: [ :view | view mouseOverIndex: boxIndex ].
]

{ #category : #'as yet unclassified' }
WTGLevelEditor >> selectionBoxViewsDo: aBlock [
	levelViews do: [ :view |
		view selectionBoxView ifNotNil: [ aBlock value: view selectionBoxView ]
	]
]

{ #category : #selection }
WTGLevelEditor >> selectionChanged [
	currentInspector ifNotNil: [ currentInspector update ].
	textureTransformEditor ifNotNil: [ textureTransformEditor selectionChanged ].
]

{ #category : #rendering }
WTGLevelEditor >> simulateTime: delta [
	super simulateTime: delta.
	levelViews do: [ :view | view simulateCameraMovement: delta ].

]

{ #category : #snapping }
WTGLevelEditor >> snapBox: box [
	^ WMBox3DD min: (self snapTranslation: box min) max: (self snapTranslation: box max)
]

{ #category : #snapping }
WTGLevelEditor >> snapTranslation: translation [
	^ WMVector3D
		x: (self roundToGrid: translation x)
		y: (self roundToGrid: translation y)
		z: (self roundToGrid: translation z)
]

{ #category : #actions }
WTGLevelEditor >> subtractSelectedBrushes [
	| affectedBrushes newBrushes entity |
	selectionBox elements ifEmpty: [ ^ self ].
	affectedBrushes := map findBrushesIntersectingSelectedBrushesProperly: selectionBox.
	affectedBrushes ifEmpty: [ ^ self ].
	
	self flag: 'Add a memento or something for undo/redo'.
	affectedBrushes do: [ :brush |
		selectionBox elements do: [ :subtractor |
			newBrushes := brush subtract: subtractor.
			entity := brush entity.
			entity removeComponent: brush.
			entity addComponents: newBrushes
		]
	]
]

{ #category : #accessing }
WTGLevelEditor >> thumbnailPaintCache [
	^ thumbnailPaintCache
]

{ #category : #accessing }
WTGLevelEditor >> thumbnailPaintCache: anObject [
	thumbnailPaintCache := anObject
]

{ #category : #selection }
WTGLevelEditor >> toggleFaceSelectMode [
	self faceSelectMode: faceSelectMode not.
	
]

{ #category : #rendering }
WTGLevelEditor >> updateCommonRenderState [
]

{ #category : #private }
WTGLevelEditor >> useNewSelectionBox: aBox [
	self assert: aBox isNotNil.
	selectionBox ifNotNil: [ selectionBox editor: nil ].
	selection ifNotNil: [ selection editor: nil . selection clearSelectedState ].

	selectionBox := aBox.
	selection := aBox.

	selectionBox ifNotNil: [ selectionBox editor: self; setSelectedState ].
	self selectionBoxViewsDo: #updateNodes.
]
