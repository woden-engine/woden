Class {
	#name : #WDGSLevelEditorModel,
	#superclass : #WDASceneModel,
	#instVars : [
		'map',
		'currentMaterialName',
		'faceSelectMode',
		'gridSize',
		'selection',
		'selectionBox',
		'currentInspector',
		'textureTransformEditor',
		'levelViews',
		'primaryGridMesh',
		'centerAxisMesh',
		'secondaryGridMesh',
		'mapFileName',
		'materialThumbDB',
		'activeSceneView'
	],
	#classVars : [
		'MaterialThumbDBFileName'
	],
	#category : #'WodenEngine-OldLevelEditor-Model'
}

{ #category : #initialization }
WDGSLevelEditorModel class >> initialize [
	super initialize.
	MaterialThumbDBFileName := 'WDGSLevelEditorModel_MaterialThumb.db'.
]

{ #category : #accessing }
WDGSLevelEditorModel >> activeSceneView [
	^ activeSceneView
]

{ #category : #accessing }
WDGSLevelEditorModel >> activeSceneView: aSceneView [
	activeSceneView := aSceneView
]

{ #category : #'modeling objects' }
WDGSLevelEditorModel >> addActiveBrushTypeAtSelectionCube [
	| brush |
	(selectionBox isEmpty or: [ selectionBox isSpaceSelection not ]) ifTrue: [ ^ self ].

	brush := WDGSBrush box: selectionBox box.
	brush material: currentMaterialName.
	map entities first addComponent: brush.
	
	selectionBox addElement: brush.
	^ brush
]

{ #category : #actions }
WDGSLevelEditorModel >> addGunItem: aPosition [
	(self addPointEntity: aPosition) addBehaviorClass: WDGSMagnumItemBehavior.
]

{ #category : #adding }
WDGSLevelEditorModel >> addLevelView: aLevelView [
	levelViews := (levelViews copyWithout: aLevelView) copyWith: aLevelView
]

{ #category : #actions }
WDGSLevelEditorModel >> addLightEntity: aPosition [
	| entity |
	entity := WDGSEntity new.
	entity
		addComponent: WDGSSpatialDescription new lookDown;
		addComponent: WDGSLightSourceComponent new.
	entity spatialDescription translation: aPosition.
	map addEntity: entity.
]

{ #category : #actions }
WDGSLevelEditorModel >> addModel: modelName [
	self addModel: modelName position: Float64x3 new.
]

{ #category : #actions }
WDGSLevelEditorModel >> addModel: modelName position: aPosition [
	| entity model |
	model := engine resourceCache loadModel: modelName.
	entity := WDGSEntity new.
	entity
		addComponent: WDGSSpatialDescription new;
		addComponent: (WDGSModel new modelName: modelName).
	entity spatialDescription
		localBoundingBox: model boundingBox asBoxF64;
		translation: aPosition.
	map addEntity: entity.
	^ entity
]

{ #category : #actions }
WDGSLevelEditorModel >> addObjectAtSelectionCube [
	| material |
	(selectionBox isEmpty or: [ selectionBox isSpaceSelection not ]) ifTrue: [ ^ self ].
	
	material := self validCurrentMaterial.
	^ material inEditor: self addObjectAtSelectionCube: selectionBox
]

{ #category : #actions }
WDGSLevelEditorModel >> addPlayerSpawnPoint: aPosition [
	| entity |
	entity := WDGSEntity new.
	entity
		addComponent: WDGSSpatialDescription new;
		addComponent: (WDGSBehaviorClass new behaviorClassName: WDGSPlayerSpawnPointBehavior name).
	entity spatialDescription
		translation: aPosition;
		localBoundingBox: (BoxF64 halfExtent: WDGSPlayerBehavior halfExtent).
	map addEntity: entity.
]

{ #category : #actions }
WDGSLevelEditorModel >> addPointEntity: aPosition [
	| entity |
	entity := WDGSEntity new.
	entity
		addComponent: WDGSSpatialDescription new.
	entity spatialDescription translation: aPosition.
	map addEntity: entity.
	^ entity
]

{ #category : #'modeling objects' }
WDGSLevelEditorModel >> addTerrainPlaneAtSelectionCubeWithMaterial: aTerrainMaterial [
	| terrainComponent |
	(selectionBox isEmpty or: [ selectionBox isSpaceSelection not ]) ifTrue: [ ^ self ].

	terrainComponent := WDGSTerrainComponent new
		materialName: currentMaterialName;
		boundingBox: selectionBox box asBoxF64 copy;
		yourself.
	
	map entities first addComponent: terrainComponent.
	selectionBox addElement: terrainComponent.
	^ terrainComponent
]

{ #category : #'modeling objects' }
WDGSLevelEditorModel >> addVolumeWithGridAtSelectionCube [
	| volumeComponent |
	(selectionBox isEmpty or: [ selectionBox isSpaceSelection not ]) ifTrue: [ ^ self ].

	volumeComponent := WDGSProceduralMeshVolumeWithTopGrid new
		materialName: currentMaterialName;
		boundingBox: selectionBox box asBoxF64 copy;
		yourself.
	
	map entities first addComponent: volumeComponent.
	selectionBox addElement: volumeComponent.
	^ volumeComponent
]

{ #category : #actions }
WDGSLevelEditorModel >> applyCurrentMaterialToSelection [
	self flag: 'Add a memento or something for undo/redo'.
	selection elements do: [ :element | element material: currentMaterialName ]
]

{ #category : #meshes }
WDGSLevelEditorModel >> centerAxisMesh [
	| start end |
	centerAxisMesh ifNotNil: [ ^ centerAxisMesh ].
	start := -10000.0.
	end := start negated. 
	
	centerAxisMesh := (WDCGenericMeshBuilder for: engine)
		material: self gridMaterial;
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
		mesh.
	^ centerAxisMesh
]

{ #category : #initialization }
WDGSLevelEditorModel >> clearScene [
	scene := WDSGScene for: engine.
	"scene backgroundColor: Color veryDarkGray darker."
	camera := WDSGCamera new.
	scene add: camera.
	self createSelectionBox
]

{ #category : #selection }
WDGSLevelEditorModel >> clearSelection [
	faceSelectMode
		ifTrue: [ self selection: WDGSLevelEditorSelection new. ]
		ifFalse: [ self selection: WDGSLevelEditorSelectionBox empty. ]
	
]

{ #category : #initialization }
WDGSLevelEditorModel >> createMap [
	| world |
	map := WDGSMap new.
	map editorMode: true.
	map scene: scene.
		
	world := WDGSEntity new.
	world worldEntity: true.
	map addEntity: world.
]

{ #category : #selection }
WDGSLevelEditorModel >> createSelectionBox [
	self selection: WDGSLevelEditorSelectionBox empty.
]

{ #category : #accessing }
WDGSLevelEditorModel >> currentMaterialName [
	^ currentMaterialName
]

{ #category : #accessing }
WDGSLevelEditorModel >> currentMaterialName: aMaterialName [
	currentMaterialName := aMaterialName
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorModel >> defaultViewClass [
	^ WDGSLevelEditorMainFrame
]

{ #category : #selection }
WDGSLevelEditorModel >> elementsAlongRay: ray do: aBlock [
	| selectionMode |
	selectionMode := self isFaceSelectMode
		ifTrue: [ #face ]
		ifFalse: [ #entity"#brush" ].
	map elementsAlongRay: ray mode: selectionMode do: aBlock
]

{ #category : #selection }
WDGSLevelEditorModel >> faceSelectMode: mode [
	faceSelectMode := mode.
	faceSelectMode ifTrue: [
		self selection: selection asElementSelection
	] ifFalse: [
		self selection: selection asBoxSelection
	]
]

{ #category : #actions }
WDGSLevelEditorModel >> fileOpen [
	self fileOpenDialog: 'Open Level' extensions: #('json') callback: [ :fileName |
		fileName ifNotNil: [
			[ self loadMapFromFileNamed: fileName ] fork
		]
	] 
]

{ #category : #dialogs }
WDGSLevelEditorModel >> fileOpenDialog: title extensions: extensions callback: callback [
	^ self fileOpenDialog: title extensions: extensions path: nil preview: nil callback: callback
]

{ #category : #dialogs }
WDGSLevelEditorModel >> fileOpenDialog: title extensions: extensions path: path callback: callback [
	^ self fileOpenDialog: title extensions: extensions path: path preview: nil callback: callback
]

{ #category : #dialogs }
WDGSLevelEditorModel >> fileOpenDialog: title extensions: extensions path: path preview: preview callback: callback [
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
WDGSLevelEditorModel >> fileSaveDialog: title extensions: extensions callback: callback [
	^ self fileSaveDialog: title initialAnswer: '' extensions: extensions path: nil callback: callback
]

{ #category : #dialogs }
WDGSLevelEditorModel >> fileSaveDialog: title initialAnswer: fileName extensions: extensions callback: callback [
	^ self fileSaveDialog: title initialAnswer: fileName extensions: extensions path: nil callback: callback
]

{ #category : #dialogs }
WDGSLevelEditorModel >> fileSaveDialog: title initialAnswer: fileName extensions: extensions path: path callback: callback [
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

{ #category : #meshes }
WDGSLevelEditorModel >> gridMaterial [
	^ engine resourceCache loadMaterial: 'materials/basic/editor-grid.json'
]

{ #category : #initialization }
WDGSLevelEditorModel >> initializeModel [
	super initializeModel.
	self loadMaterialThumbDB.
	levelViews := #().
	currentMaterialName := ''.
	faceSelectMode := false.
	gridSize := 1.0.
	self
		clearScene;
		createMap
]

{ #category : #actions }
WDGSLevelEditorModel >> inspectSelection [
	currentInspector ifNotNil: [ ^ self ].
	currentInspector := GTInspector new.
	(currentInspector openInExternalWindowOn: self)
		extent: 640@480;
		closeCallback: [ currentInspector := nil ].
]

{ #category : #selection }
WDGSLevelEditorModel >> isFaceSelectMode [
	^ faceSelectMode
]

{ #category : #actions }
WDGSLevelEditorModel >> loadMapFromFileNamed: fileName [
	| newMap |
	newMap := WDGSMap loadJsonFromFileNamed: fileName.
	newMap editorMode: true.
	mapFileName := fileName.
	map ifNotNil: [ map scene: nil ].
	map := newMap.
	map scene: scene.
]

{ #category : #thumbnail }
WDGSLevelEditorModel >> loadMaterialThumbDB [
	materialThumbDB := WDCResourceThumbnailDB tryToLoadFromFileNamed: MaterialThumbDBFileName.
	engine resourceCache ensureAllMaterialThumbnailsInDB: materialThumbDB.
	materialThumbDB saveTo: MaterialThumbDBFileName
]

{ #category : #actions }
WDGSLevelEditorModel >> makeBrushEntity [
	| selectedBrushes |
	selectedBrushes := selection elements select: #isBrush.
	selectedBrushes ifEmpty: [ ^ self ].
	
	Transcript show: selectedBrushes; cr.
]

{ #category : #accessing }
WDGSLevelEditorModel >> map [
	^ map
]

{ #category : #accessing }
WDGSLevelEditorModel >> map: anObject [
	map := anObject
]

{ #category : #accessing }
WDGSLevelEditorModel >> materialThumbDB [
	^ materialThumbDB
]

{ #category : #'mouse over' }
WDGSLevelEditorModel >> mouseOverNone [
	self selectionBoxViewsDo: [ :view | view mouseOverIndex: -1 ].
]

{ #category : #actions }
WDGSLevelEditorModel >> openTextureTransformEditor [
	| textureTransformEditorWindow |
	textureTransformEditor ifNotNil: [ ^ self ].
	textureTransformEditor := WDGSLevelEditorTextureTransformSpec new editor: self.
	self flag: 'Spec should provide a mechanism for this'.
	textureTransformEditorWindow := textureTransformEditor openExternalWindowWithSpec window value.
	textureTransformEditorWindow closeCallback: [ textureTransformEditor := nil ].
	textureTransformEditor selectionChanged.
	textureTransformEditorWindow changed
]

{ #category : #actions }
WDGSLevelEditorModel >> playInExternalWindow [
	map playModeCopy play
]

{ #category : #meshes }
WDGSLevelEditorModel >> primaryGridMesh [
	primaryGridMesh ifNotNil: [ ^ primaryGridMesh ].
	primaryGridMesh := (WDCGenericMeshBuilder for: engine)
		material: self gridMaterial;
		color: Color gray;
		addLineGridWithWidth: 200 height: 200 subdivisions: 21;
		mesh.
	^ primaryGridMesh
]

{ #category : #snapping }
WDGSLevelEditorModel >> primaryGridSize [
	^ gridSize
]

{ #category : #actions }
WDGSLevelEditorModel >> removeSelectedComponents [
	selection elements do: [ :element | element removeFromMap ].
	self selection: WDGSLevelEditorSelectionBox empty
]

{ #category : #snapping }
WDGSLevelEditorModel >> roundToGrid: value [
	| quantum |
	quantum := self secondaryGridSize.
	^ ((value / quantum) + 0.5) floor * quantum
]

{ #category : #actions }
WDGSLevelEditorModel >> save [
	mapFileName ifNil: [ ^ self saveAs ].
	self saveMapToFileNamed: mapFileName.
	
]

{ #category : #actions }
WDGSLevelEditorModel >> saveAs [
	self fileSaveDialog: 'Save Level' extensions: #('json') callback: [ :fileName |
		fileName ifNotNil: [
			[ self saveMapToFileNamed: fileName ] fork
		]
	] 
]

{ #category : #actions }
WDGSLevelEditorModel >> saveMapToFileNamed: fileName [
	map saveJsonToFile: fileName.
	mapFileName := fileName.
]

{ #category : #meshes }
WDGSLevelEditorModel >> secondaryGridMesh [
	secondaryGridMesh ifNotNil: [ ^ secondaryGridMesh ].
	secondaryGridMesh := (WDCGenericMeshBuilder for: engine)
		material: self gridMaterial;
		color: Color darkGray;
		addLineGridWithWidth: 200 height: 200 subdivisions: 201;
		mesh.
	^ secondaryGridMesh
]

{ #category : #snapping }
WDGSLevelEditorModel >> secondaryGridSize [
	^ gridSize * 0.1
]

{ #category : #selection }
WDGSLevelEditorModel >> selection [
	^ selection
]

{ #category : #selection }
WDGSLevelEditorModel >> selection: aSelection [
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
WDGSLevelEditorModel >> selectionBox [
	^ selectionBox
]

{ #category : #'mouse over' }
WDGSLevelEditorModel >> selectionBoxMouseOver: boxIndex [
	self selectionBoxViewsDo: [ :view | view mouseOverIndex: boxIndex ].
]

{ #category : #selection }
WDGSLevelEditorModel >> selectionBoxViewsDo: aBlock [
	levelViews do: [ :view |
		view selectionBoxView ifNotNil: [ aBlock value: view selectionBoxView ]
	]
]

{ #category : #selection }
WDGSLevelEditorModel >> selectionChanged [
	currentInspector ifNotNil: [ currentInspector update ].
	textureTransformEditor ifNotNil: [ textureTransformEditor selectionChanged ].
]

{ #category : #snapping }
WDGSLevelEditorModel >> snapBox: box [
	^ BoxF64 min: (self snapTranslation: box min) max: (self snapTranslation: box max)
]

{ #category : #snapping }
WDGSLevelEditorModel >> snapTranslation: translation [
	^ Float64x3
		x: (self roundToGrid: translation x)
		y: (self roundToGrid: translation y)
		z: (self roundToGrid: translation z)
]

{ #category : #actions }
WDGSLevelEditorModel >> subtractSelectedBrushes [
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

{ #category : #selection }
WDGSLevelEditorModel >> toggleFaceSelectMode [
	self faceSelectMode: faceSelectMode not.
]

{ #category : #selection }
WDGSLevelEditorModel >> useNewSelectionBox: aBox [
	self assert: aBox isNotNil.
	selectionBox ifNotNil: [ selectionBox editor: nil ].
	selection ifNotNil: [ selection editor: nil . selection clearSelectedState ].

	selectionBox := aBox.
	selection := aBox.

	selectionBox ifNotNil: [ selectionBox editor: self; setSelectedState ].
	self selectionBoxViewsDo: #updateNodes.
]

{ #category : #accessing }
WDGSLevelEditorModel >> validCurrentMaterial [
	^ engine resourceCache loadMaterial: currentMaterialName fallback: [ engine resourceCache defaultMaterial ]
]
