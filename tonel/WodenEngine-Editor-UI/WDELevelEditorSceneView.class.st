Class {
	#name : #WDELevelEditorSceneView,
	#superclass : #WDASceneViewWithBabylon,
	#instVars : [
		'activeToolMode',
		'activeEditionMode',
		'cameraAngle',
		'renderSubMode',
		'editorViewType',
		'gridOrientation',
		'isPerspective',
		'viewScale'
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
WDELevelEditorSceneView >> activeToolMode: anObject [
	activeToolMode := anObject
]

{ #category : #accessing }
WDELevelEditorSceneView >> activeToolModeOrEditionMode [
	^ activeToolMode ifNil: [ self activeEditionMode ]
]

{ #category : #'as yet unclassified' }
WDELevelEditorSceneView >> cameraXYDeltaToWorld: screenDelta [
	^ (screenDelta x * self xDragDirection) + (screenDelta y * self yDragDirection)
]

{ #category : #'as yet unclassified' }
WDELevelEditorSceneView >> cameraXZDeltaToWorld: screenDelta [
	^ (screenDelta x * self xDragDirection) + (screenDelta y * self zDragDirection)
]

{ #category : #accessing }
WDELevelEditorSceneView >> editorViewType [
	^ editorViewType
]

{ #category : #visiting }
WDELevelEditorSceneView >> elementInPosition: aPoint [
	^ self elementInPositionWithRayPicking: aPoint

]

{ #category : #visiting }
WDELevelEditorSceneView >> elementInPositionWithRayPicking: aPoint [
	| nx ny extent |
	extent := self drawingSurfaceExtent.
	nx := aPoint x / extent x asFloat.
	ny := 1.0 - (aPoint y / extent y).
	^ self rayPickNormalizedPosition: nx @ ny.

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
WDELevelEditorSceneView >> rayPickNormalizedPosition: aPoint [
	| ray distanceElement |
	ray := self camera ifNil: [ ^ nil ] ifNotNil: [:c | self worldRayAtWindowCoordinate: aPoint fromCamera: c].
	ray ifNil: [ ^ nil ].
	
	distanceElement := model rayCast: ray.
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

{ #category : #'view perspective' }
WDELevelEditorSceneView >> sideView [
	cameraAngle := Float32x3 y: Float halfPi.
	gridOrientation := Float32x3x3 lookAtLeft.
	editorViewType := #side.
]

{ #category : #snapping }
WDELevelEditorSceneView >> subGridSize [
	^ model subGridSize
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
