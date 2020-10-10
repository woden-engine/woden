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
		'isPerspective'
	],
	#category : #'WodenEngine-Editor-UI'
}

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
	gridOrientation := Float32x3x3 lookAtBottom.
	editorViewType := #free.
]

{ #category : #'view perspective' }
WDELevelEditorSceneView >> frontView [
	cameraAngle := Float32x3 zeros.
	gridOrientation := Float32x3x3 lookAtFront.
	editorViewType := #front.
]

{ #category : #initialization }
WDELevelEditorSceneView >> initialize [
	super initialize.

	cameraAngle := Float32x3 new.
	isPerspective := true.
	self freePerspectiveView.
]

{ #category : #accessing }
WDELevelEditorSceneView >> isPerspective [
	^ isPerspective
]

{ #category : #accessing }
WDELevelEditorSceneView >> isPerspective: anObject [
	isPerspective := anObject
]

{ #category : #'view perspective' }
WDELevelEditorSceneView >> orthographicView [
	isPerspective := false
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

{ #category : #'view perspective' }
WDELevelEditorSceneView >> sideView [
	cameraAngle := Float32x3 y: Float halfPi.
	gridOrientation := Float32x3x3 lookAtLeft.
	editorViewType := #side.
]

{ #category : #'view perspective' }
WDELevelEditorSceneView >> topView [
	cameraAngle := Float32x3 x: Float halfPi negated.
	gridOrientation := Float32x3x3 lookAtBottom.
	editorViewType := #top.
]

{ #category : #'as yet unclassified' }
WDELevelEditorSceneView >> translateCameraBy: translation [
	self camera translateBy: (self camera transform matrix * translation)
]

{ #category : #initialization }
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
	
	self updateGridsForCamera.
]

{ #category : #initialization }
WDELevelEditorSceneView >> updateGridsForCamera [
	| gridPosition gridTransform renderPriority |
	renderPriority := isPerspective
		ifTrue: [ WDCAbstractRenderable renderPriorityEditorOpaqueAfter ]
		ifFalse: [ WDCAbstractRenderable renderPriorityEditorOpaqueBefore ].
		
	gridPosition := Float32x3 zeros.	
	gridTransform := ReversibleAffineTransform3dF32 identity orthonormal: gridOrientation translation: gridPosition.
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
