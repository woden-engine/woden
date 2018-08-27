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
		'secondaryGridMesh'
	],
	#category : #'WodenEngine-LevelEditor-Model'
}

{ #category : #adding }
WDGSLevelEditorModel >> addLevelView: aLevelView [
	levelViews := (levelViews copyWithout: aLevelView) copyWith: aLevelView
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

{ #category : #initialization }
WDGSLevelEditorModel >> clearScene [
	scene := WDSGScene for: engine.
	"scene backgroundColor: Color veryDarkGray darker."
	camera := WDSGCamera new.
	scene add: camera.
	self createSelectionBox
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
	self selection: WTGLevelEditorSelectionBox empty.
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorModel >> defaultViewClass [
	^ WDGSLevelEditorMainFrame
]

{ #category : #meshes }
WDGSLevelEditorModel >> gridMaterial [
	^ engine resourceCache loadMaterial: 'materials/basic/editor-grid.json'
]

{ #category : #initialization }
WDGSLevelEditorModel >> initializeModel [
	super initializeModel.
	levelViews := #().
	currentMaterialName := ''.
	faceSelectMode := false.
	gridSize := 1.0.
	self
		clearScene;
		createMap
]

{ #category : #accessing }
WDGSLevelEditorModel >> map [
	^ map
]

{ #category : #accessing }
WDGSLevelEditorModel >> map: anObject [
	map := anObject
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

{ #category : #snapping }
WDGSLevelEditorModel >> roundToGrid: value [
	| quantum |
	quantum := self secondaryGridSize.
	^ ((value / quantum) + 0.5) floor * quantum
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
		self useNewSelectionBox: WTGLevelEditorSelectionBox empty.
		selection := aSelection.
		selection setSelectedState.
	].
	self selectionChanged.
]

{ #category : #selection }
WDGSLevelEditorModel >> selectionBox [
	^ selectionBox
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
	^ WMBox3DD min: (self snapTranslation: box min) max: (self snapTranslation: box max)
]

{ #category : #snapping }
WDGSLevelEditorModel >> snapTranslation: translation [
	^ WMVector3D
		x: (self roundToGrid: translation x)
		y: (self roundToGrid: translation y)
		z: (self roundToGrid: translation z)
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
