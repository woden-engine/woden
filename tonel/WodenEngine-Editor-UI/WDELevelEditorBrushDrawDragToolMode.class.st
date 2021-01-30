Class {
	#name : #WDELevelEditorBrushDrawDragToolMode,
	#superclass : #WDELevelEditorViewDragToolMode,
	#instVars : [
		'sceneNode'
	],
	#category : #'WodenEngine-Editor-UI-ViewMode'
}

{ #category : #'event handling' }
WDELevelEditorBrushDrawDragToolMode >> applyBoxToSceneNode: box [
	sceneNode ifNil: [ self createSceneNode ].
	sceneNode
		transform: box reversibleTransformToConvertUnitBoxToMe
]

{ #category : #'event handling' }
WDELevelEditorBrushDrawDragToolMode >> computeBoxWithScreenEndPoint: screenEndPoint [
	| dragMinDistance startPosition endPosition dragMaxDistance box |
	dragMinDistance := 5.0.
	dragMaxDistance := 6.0.
	startPosition := self cameraXYToWorld: dragStartPosition distance: dragMinDistance.
	endPosition := self cameraXYToWorld: screenEndPoint distance: dragMaxDistance.
	box := BoxF32 min: (startPosition min: endPosition) max: (startPosition max: endPosition).

	self levelEditorSession activeSectorLayer ifNotNil: [ :sectorLayer |
		sectorLayer isInSector2D ifTrue: [
			box min z: sectorLayer defaultMinZ.
			box max z: sectorLayer defaultMaxZ.
		]
	].
	box min: (view snapToSubGrid: box min).
	box max: (view snapToSubGrid: box max).
	^ box
]

{ #category : #'event handling' }
WDELevelEditorBrushDrawDragToolMode >> createSceneNode [
	sceneNode := WDSGSpatialObject new
		renderable: (self engine resourceCache flatShadedTranslucentUnitCubeMesh copy 		setFlatColorSubRenderMode;
		isOpaqueShadowCaster: false;
		yourself);
		color: (Float32x4 x: 1.0 y: 1.0 z: 1.0 w: 0.3);
		yourself.
	self scene add: sceneNode
]

{ #category : #'events-processing' }
WDELevelEditorBrushDrawDragToolMode >> finishDraggingWith: event [
	| box |
	super finishDraggingWith: event.
	sceneNode ifNotNil: [ sceneNode removeFromScene ].
	box := self computeBoxWithScreenEndPoint: dragEndPosition.
	(box isEmpty not and: [ box width > 0 and: [ box height > 0 and: [ box depth > 0 ] ] ]) ifTrue: [ 
		self model activeToolManipulator: ((WDELevelEditor3DBoxPlacementManipulator for: self model)
			isManipulating2DGeometry: self levelEditorSession activeSectorLayer isInSector2D;
			boundingBox: box;
			yourself)
	] ifFalse: [
		self model activeToolManipulator: nil
	]

]

{ #category : #'event handling' }
WDELevelEditorBrushDrawDragToolMode >> onMouseDrag: event [
	| box |
	super onMouseDrag: event.
	box := self computeBoxWithScreenEndPoint: event position.
	self applyBoxToSceneNode: box.

]
