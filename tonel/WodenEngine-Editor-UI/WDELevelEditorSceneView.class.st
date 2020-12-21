Class {
	#name : #WDELevelEditorSceneView,
	#superclass : #WDASceneViewWith2DOverlay,
	#instVars : [
		'activeToolMode',
		'activeEditionMode',
		'cameraAngle',
		'renderSubMode',
		'editorViewType',
		'gridOrientation',
		'isPerspective',
		'viewScale',
		'dragToolScreenOverlay'
	],
	#category : #'WodenEngine-Editor-UI'
}

{ #category : #'as yet unclassified' }
WDELevelEditorSceneView class >> defaultOrthographicFarDistance [
	^ 10000.0
]

{ #category : #'as yet unclassified' }
WDELevelEditorSceneView class >> defaultOrthographicNearDistance [
	^ -10000.0
]

{ #category : #'as yet unclassified' }
WDELevelEditorSceneView class >> defaultPerspectiveFarDistance [
	^ 10000.0
]

{ #category : #'as yet unclassified' }
WDELevelEditorSceneView class >> defaultPerspectiveNearDistance [
	^ 0.01
]

{ #category : #'sub render mode' }
WDELevelEditorSceneView >> activateFlatColor [
	^ self renderSubMode: WDCStateTrackerSubRenderMode flatColor
]

{ #category : #'sub render mode' }
WDELevelEditorSceneView >> activateFlatTextured [
	^ self renderSubMode: WDCStateTrackerSubRenderMode flatTextured
]

{ #category : #'sub render mode' }
WDELevelEditorSceneView >> activateFullShaded [
	^ self renderSubMode: WDCStateTrackerSubRenderMode fullShaded
]

{ #category : #'sub render mode' }
WDELevelEditorSceneView >> activateMaterialValidation [
	^ self renderSubMode: WDCStateTrackerSubRenderMode materialValidation
]

{ #category : #'editor modes' }
WDELevelEditorSceneView >> activateObjectMode [
	self activeEditionMode: (WDELevelEditorViewObjectEditionMode for: self)
]

{ #category : #'editor modes' }
WDELevelEditorSceneView >> activatePlacementMode [
	self activeEditionMode: (WDELevelEditorViewPlacementMode for: self)
]

{ #category : #'sub render mode' }
WDELevelEditorSceneView >> activateShadedColor [
	^ self renderSubMode: WDCStateTrackerSubRenderMode shadedColor
]

{ #category : #'sub render mode' }
WDELevelEditorSceneView >> activateWireFrame [
	^ self renderSubMode: WDCStateTrackerSubRenderMode wireframe
]

{ #category : #accessing }
WDELevelEditorSceneView >> activeEditionMode [
	^ activeEditionMode ifNil: [ activeEditionMode := WDELevelEditorViewObjectEditionMode for: self  ]
]

{ #category : #accessing }
WDELevelEditorSceneView >> activeEditionMode: newEditionMode [
	^ activeEditionMode := newEditionMode
]

{ #category : #accessing }
WDELevelEditorSceneView >> activeToolMode: anObject [
	activeToolMode := anObject
]

{ #category : #accessing }
WDELevelEditorSceneView >> activeToolModeOrEditionMode [
	^ activeToolMode ifNil: [ self activeEditionMode ]
]

{ #category : #selection }
WDELevelEditorSceneView >> addElementsToSelection: elements [
	^ model levelEditorSession addElementsToSelection: elements
]

{ #category : #'as yet unclassified' }
WDELevelEditorSceneView >> cameraXYDeltaToWorld: screenDelta [
	^ self cameraXYDeltaToWorld: screenDelta distance: 3.0
]

{ #category : #'as yet unclassified' }
WDELevelEditorSceneView >> cameraXYDeltaToWorld: screenDelta distance: screenDistance [
	| depth cameraDelta |
	depth := self depthAtCameraDistance: screenDistance.
	cameraDelta := (self windowToLocal: screenDelta depth: depth) - (self windowToLocal: 0@0 depth: depth).
	^ (cameraDelta x * self xDragDirection) + (cameraDelta y * self yDragDirection)
]

{ #category : #'as yet unclassified' }
WDELevelEditorSceneView >> cameraXYToWorld: screenPosition distance: screenDistance [
	| depth cameraPosition |
	depth := self depthAtCameraDistance: screenDistance.
	cameraPosition := (self windowToLocal: screenPosition depth: depth).
	^ self camera position +
	(cameraPosition x * self xDragDirection) + (cameraPosition y * self yDragDirection) + (screenDistance * self zDragDirection)
]

{ #category : #'as yet unclassified' }
WDELevelEditorSceneView >> cameraXZDeltaToWorld: screenDelta [
	^ self cameraXZDeltaToWorld: screenDelta distance: 3.0
]

{ #category : #'as yet unclassified' }
WDELevelEditorSceneView >> cameraXZDeltaToWorld: screenDelta distance: screenDistance [
	| depth cameraDelta |
	depth := self depthAtCameraDistance: screenDistance.
	cameraDelta := (self windowToLocal: screenDelta depth: depth) - (self windowToLocal: 0@0 depth: depth).
	^ (cameraDelta x * self xDragDirection) + (cameraDelta y * self zDragDirection)
]

{ #category : #'as yet unclassified' }
WDELevelEditorSceneView >> computeScreenDistanceForPoint: aPoint [
	^ (self camera globalTransform inverseTransformPosition: aPoint) z negated
]

{ #category : #'coordinate systems' }
WDELevelEditorSceneView >> depthAtCameraDistance: distance [
	^ isPerspective
		ifTrue: [ (distance - self perspectiveNearDistance) / (self perspectiveFarDistance - self perspectiveNearDistance) ]
		ifFalse: [ (distance - self orthographicNearDistance) / (self orthographicFarDistance - self orthographicNearDistance) ]
]

{ #category : #accessing }
WDELevelEditorSceneView >> dragToolScreenOverlay [
	^ dragToolScreenOverlay
]

{ #category : #accessing }
WDELevelEditorSceneView >> dragToolScreenOverlay: anObject [
	dragToolScreenOverlay := anObject
]

{ #category : #rendering }
WDELevelEditorSceneView >> drawOnBabylonCanvas: canvas [
	super drawOnBabylonCanvas: canvas.
	dragToolScreenOverlay ifNotNil: [ dragToolScreenOverlay drawOnBabylonCanvas: canvas ].
]

{ #category : #accessing }
WDELevelEditorSceneView >> editorViewType [
	^ editorViewType
]

{ #category : #visiting }
WDELevelEditorSceneView >> elementInPositionWithRayPicking: aPoint [
	^ self rayPickElement: (self rayForScreenPosition: aPoint)
]

{ #category : #visiting }
WDELevelEditorSceneView >> elementInScreenPosition: aPoint [
	^ self elementInPositionWithRayPicking: aPoint

]

{ #category : #visiting }
WDELevelEditorSceneView >> elementsInScreenRectangle: screenRectangle [
	| originPosition cornerPosition normalizedScreenRectangle selectionFrustum |
	originPosition := (self normalizeScreenPosition: screenRectangle origin) asFloat32x2.
	cornerPosition := (self normalizeScreenPosition: screenRectangle corner) asFloat32x2.
	normalizedScreenRectangle := RectangleF32 min: (originPosition min: cornerPosition) max: (originPosition max: cornerPosition).
	
	selectionFrustum := ((self camera frustum splitAtLeftLambda: normalizedScreenRectangle min x rightLambda: normalizedScreenRectangle max x)
			splitAtBottomLambda: normalizedScreenRectangle min y topLambda: normalizedScreenRectangle max y)
			transformedWith: self camera globalTransform.
	^ model elementsInFrustum: selectionFrustum
]

{ #category : #'view perspective' }
WDELevelEditorSceneView >> freePerspectiveView [
	gridOrientation := self topGridOrientation.
	editorViewType := #free.
]

{ #category : #'view perspective' }
WDELevelEditorSceneView >> frontView [
	cameraAngle := Float32x3 zeros.
	gridOrientation := Float32x3x3 lookAtFront.
	editorViewType := #front.
]

{ #category : #snapping }
WDELevelEditorSceneView >> gridSize [
	^ model gridSize
]

{ #category : #initialization }
WDELevelEditorSceneView >> initialize [
	super initialize.

	cameraAngle := Float32x3 new.
	isPerspective := true.
	viewScale := 3.0.
	self frontView.
]

{ #category : #accessing }
WDELevelEditorSceneView >> isPerspective [
	^ isPerspective
]

{ #category : #accessing }
WDELevelEditorSceneView >> isPerspective: anObject [
	isPerspective := anObject
]

{ #category : #visiting }
WDELevelEditorSceneView >> manipulatorInPositionWithRayPicking: aPoint [
	^ self rayPickManipulator: (self rayForScreenPosition: aPoint)
]

{ #category : #visiting }
WDELevelEditorSceneView >> manipulatorInScreenPosition: aPoint [
	^ self manipulatorInPositionWithRayPicking: aPoint

]

{ #category : #visiting }
WDELevelEditorSceneView >> normalizeScreenPosition: aPoint [
	| nx ny extent |
	extent := self drawingSurfaceExtent.
	nx := aPoint x / extent x asFloat.
	ny := 1.0 - (aPoint y / extent y).
	^ nx @ ny
]

{ #category : #'as yet unclassified' }
WDELevelEditorSceneView >> normalizedToLocal: aPosition depth: aDepth [
	^ self camera frustum normalizedPoint: aPosition linearDepth: aDepth
]

{ #category : #accessing }
WDELevelEditorSceneView >> orthographicFarDistance [
	^ self class defaultOrthographicFarDistance
]

{ #category : #accessing }
WDELevelEditorSceneView >> orthographicNearDistance [
	^ self class defaultOrthographicNearDistance
]

{ #category : #'view perspective' }
WDELevelEditorSceneView >> orthographicView [
	isPerspective := false
]

{ #category : #accessing }
WDELevelEditorSceneView >> perspectiveFarDistance [
	^ self class defaultPerspectiveFarDistance
]

{ #category : #accessing }
WDELevelEditorSceneView >> perspectiveNearDistance [
	^ self class defaultPerspectiveNearDistance
]

{ #category : #'view perspective' }
WDELevelEditorSceneView >> perspectiveView [
	isPerspective := true
]

{ #category : #visiting }
WDELevelEditorSceneView >> rayForNormalizedPosition: aPoint [
	^ self camera ifNotNil: [:c | self worldRayAtWindowCoordinate: aPoint fromCamera: c]
]

{ #category : #visiting }
WDELevelEditorSceneView >> rayForScreenPosition: aPoint [
	^ self rayForNormalizedPosition: (self normalizeScreenPosition: aPoint)
]

{ #category : #visiting }
WDELevelEditorSceneView >> rayPickElement: ray [
	| distanceElement |
	distanceElement := model rayCast: ray.
	^ distanceElement value ifNil: [ nil ]
	
]

{ #category : #visiting }
WDELevelEditorSceneView >> rayPickManipulator: ray [
	| distanceElement |
	distanceElement := model rayCastForManipulator: ray.
	^ distanceElement value ifNil: [ nil ]
]

{ #category : #accessing }
WDELevelEditorSceneView >> renderSubMode [
	^ renderSubMode ifNil: [ renderSubMode := WDCStateTrackerSubRenderMode fullShaded ]
]

{ #category : #accessing }
WDELevelEditorSceneView >> renderSubMode: aMode [
	renderSubMode := aMode
]

{ #category : #'as yet unclassified' }
WDELevelEditorSceneView >> rotateCameraWithAngles: deltaAngles [
	cameraAngle := cameraAngle + deltaAngles.
]

{ #category : #utiltity }
WDELevelEditorSceneView >> roundFloor: value quantum: quantum [
	^ model roundFloor: value quantum: quantum
]

{ #category : #selection }
WDELevelEditorSceneView >> setSelectedElements: elements [
	^ model levelEditorSession setSelectedElements: elements
]

{ #category : #'view perspective' }
WDELevelEditorSceneView >> sideView [
	cameraAngle := Float32x3 y: Float halfPi.
	gridOrientation := Float32x3x3 lookAtLeft.
	editorViewType := #side.
]

{ #category : #snapping }
WDELevelEditorSceneView >> snapToGrid: vector [
	^ model snapToGrid: vector
]

{ #category : #snapping }
WDELevelEditorSceneView >> snapToSubGrid: vector [
	^ model snapToSubGrid: vector
]

{ #category : #snapping }
WDELevelEditorSceneView >> subGridSize [
	^ model subGridSize
]

{ #category : #selection }
WDELevelEditorSceneView >> toggleElementsFromSelection: elements [
	^ model levelEditorSession toggleElementsFromSelection: elements
]

{ #category : #'projection mode' }
WDELevelEditorSceneView >> togglePerspective [
	isPerspective := isPerspective not
]

{ #category : #'view perspective' }
WDELevelEditorSceneView >> topGridOrientation [
	^ Float32x3x3 lookAtBottom
]

{ #category : #'view perspective' }
WDELevelEditorSceneView >> topView [
	cameraAngle := Float32x3 x: Float halfPi negated.
	gridOrientation := self topGridOrientation.
	editorViewType := #top.
]

{ #category : #'as yet unclassified' }
WDELevelEditorSceneView >> translateCameraBy: translation [
	self camera translateBy: translation
]

{ #category : #updating }
WDELevelEditorSceneView >> updateCameraProjection [
	camera isPerspective: isPerspective.
	camera focalDistance: (viewScale / ((camera fieldOfView * 0.5) degreesToRadians tan)).
	isPerspective ifTrue: [
		camera nearDistance: self perspectiveNearDistance; farDistance: self perspectiveFarDistance
	] ifFalse: [
		camera nearDistance: self orthographicNearDistance; farDistance: self orthographicFarDistance.
	]
]

{ #category : #updating }
WDELevelEditorSceneView >> updateForFrameDelta: delta [
	| orientation cameraTransform cameraPosition |
	super updateForFrameDelta: delta.
	camera := self camera.
	cameraPosition := self camera transform translation.

	orientation := screenDisplayMode isVR ifTrue: [ 
		Float32x3x3 yRotation: cameraAngle y.
	] ifFalse: [ 
		(Float32x3x3 yRotation: cameraAngle y) * (Float32x3x3 xRotation: cameraAngle x).
	].
	cameraTransform := ReversibleAffineTransform3dF32 identity orthonormal: orientation translation: cameraPosition.
	
	self camera transform: cameraTransform.
	
	self
		updateCameraProjection;
		updateGridsForCamera.
]

{ #category : #updating }
WDELevelEditorSceneView >> updateGridsForCamera [
	| gridPosition orientation gridTransform renderPriority scale u v cameraPosition du dv |
	renderPriority := isPerspective
		ifTrue: [ WDCAbstractRenderable renderPriorityEditorOpaqueAfter ]
		ifFalse: [ WDCAbstractRenderable renderPriorityEditorOpaqueBefore ].
		
	orientation := isPerspective
		ifTrue: [ self topGridOrientation ]
		ifFalse: [ gridOrientation ].

	scale := self gridSize / model baseGridSize.
	u := orientation firstRow.
	v := orientation secondRow.

	cameraPosition := self camera position.
	du := self roundFloor: (u dot: cameraPosition) quantum: self gridSize.
	dv := self roundFloor: (v dot: cameraPosition) quantum: self gridSize.

	gridPosition := (u * du) + (v * dv).	
	gridTransform := ReversibleAffineTransform3dF32 identity
		orthonormal: orientation;
		scaleBy: scale;
		translation: gridPosition.
	model subGridNode ifNotNil: [ :node |
		node transform: gridTransform.
		node renderable renderPriority: renderPriority
	].
	model gridNode ifNotNil: [ :node |
		node transform: gridTransform.
		node renderable renderPriority: renderPriority + 1
	].
	model axisNode ifNotNil: [ :node |
		node renderable renderPriority: renderPriority + 2
	].
]

{ #category : #accessing }
WDELevelEditorSceneView >> viewScale [
	^ viewScale
]

{ #category : #accessing }
WDELevelEditorSceneView >> viewScale: anObject [
	viewScale := anObject
]

{ #category : #visiting }
WDELevelEditorSceneView >> visitKeyDownEvent: event [
	^ self activeToolModeOrEditionMode onKeyDown: event
]

{ #category : #visiting }
WDELevelEditorSceneView >> visitKeyUpEvent: event [
	^ self activeToolModeOrEditionMode onKeyUp: event
]

{ #category : #visiting }
WDELevelEditorSceneView >> visitMouseButtonPressEvent: event [
	^ self activeToolModeOrEditionMode onMouseButtonPress: event
]

{ #category : #visiting }
WDELevelEditorSceneView >> visitMouseButtonReleaseEvent: event [
	^ self activeToolModeOrEditionMode onMouseButtonRelease: event
]

{ #category : #visiting }
WDELevelEditorSceneView >> visitMouseMoveEvent: event [
	^ self activeToolModeOrEditionMode onMouseMove: event
]

{ #category : #visiting }
WDELevelEditorSceneView >> visitMouseWheelEvent: event [
	^ self activeToolModeOrEditionMode onMouseWheel: event
]

{ #category : #'as yet unclassified' }
WDELevelEditorSceneView >> windowToLocal: aPosition depth: aDepth [
	^ self normalizedToLocal: (self normalizeScreenPosition: aPosition) depth: aDepth
]

{ #category : #visiting }
WDELevelEditorSceneView >> worldRayAtWindowCoordinate: point fromCamera: aCamera [
	| ray frustum |
	frustum := aCamera frustum.
	frustum leftBottomFar ifNil: [ ^ nil ].
	
	ray := frustum rayForNormalizedPoint: point.
	^ ray transformedWith: aCamera globalTransform
]

{ #category : #'coordinate systems' }
WDELevelEditorSceneView >> xDragDirection [
	^ self camera transform matrix firstColumn
]

{ #category : #'coordinate systems' }
WDELevelEditorSceneView >> xyDragDirection [
	^ self xDragDirection + self yDragDirection
]

{ #category : #'coordinate systems' }
WDELevelEditorSceneView >> yDragDirection [
	^ self camera transform matrix secondColumn
]

{ #category : #'coordinate systems' }
WDELevelEditorSceneView >> zDragDirection [
	^ self camera transform matrix thirdColumn negated
]
