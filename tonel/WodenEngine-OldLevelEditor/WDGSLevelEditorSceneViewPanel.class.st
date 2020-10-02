Class {
	#name : #WDGSLevelEditorSceneViewPanel,
	#superclass : #WDGSLevelEditorViewComponent,
	#instVars : [
		'view',
		'virtualWindow',
		'selectionBoxView',
		'cameraTransform',
		'cameraVelocity',
		'cameraSpeed',
		'cameraAngle',
		'cameraAngularVelocity',
		'cameraAngularSpeed',
		'viewScale',
		'gridOrientation',
		'renderMode',
		'isPerspective',
		'camera',
		'baseGridSize',
		'primaryGrid',
		'secondaryGrid',
		'centerAxis',
		'toolController',
		'lastDragEndPosition',
		'lastClickElements',
		'nextClickElementIndex',
		'editorViewType'
	],
	#classVars : [
		'OrthographicFarDistance',
		'OrthographicNearDistance',
		'PerspectiveFarDistance',
		'PerspectiveNearDistance'
	],
	#category : #'WodenEngine-OldLevelEditor-View'
}

{ #category : #initialization }
WDGSLevelEditorSceneViewPanel class >> initialize [
	super initialize.
	PerspectiveNearDistance := 0.01.
	PerspectiveFarDistance := 10000.0.
	
	OrthographicNearDistance := -10000.0.
	OrthographicFarDistance := OrthographicNearDistance negated.

]

{ #category : #accessing }
WDGSLevelEditorSceneViewPanel >> boundsChanged [
	super boundsChanged.
	virtualWindow ifNotNil: [ virtualWindow extent: self extent asIntegerPoint ].
	self changed.
]

{ #category : #drawing }
WDGSLevelEditorSceneViewPanel >> buildMeshContentOn: meshBuilder [
	super buildMeshContentOn: meshBuilder.
	virtualWindow ifNotNil: [
		meshBuilder fill
			texture: virtualWindow validResolveRenderTarget currentFramebuffer colorAttachments first rectangle: self localBounds
	]
]

{ #category : #accessing }
WDGSLevelEditorSceneViewPanel >> camera [
	^ camera
]

{ #category : #accessing }
WDGSLevelEditorSceneViewPanel >> cameraAngle [
	^ cameraAngle
]

{ #category : #accessing }
WDGSLevelEditorSceneViewPanel >> cameraAngle: anEulerAngle [
	cameraAngle := anEulerAngle
]

{ #category : #accessing }
WDGSLevelEditorSceneViewPanel >> cameraTransform [
	^ cameraTransform
]

{ #category : #testing }
WDGSLevelEditorSceneViewPanel >> canHaveDragEvents [
	^ true
]

{ #category : #testing }
WDGSLevelEditorSceneViewPanel >> canHaveKeyboardFocus [
	^ true
]

{ #category : #testing }
WDGSLevelEditorSceneViewPanel >> canHaveMouseFocus [
	^ true
]

{ #category : #camera }
WDGSLevelEditorSceneViewPanel >> computeAspectRatio [
	| myExtent |
	myExtent := self extent.
	(myExtent y asFloat closeTo: 0.0)
		ifTrue: [ ^ 1.0 ].
	^ myExtent x asFloat / myExtent y asFloat
]

{ #category : #initialization }
WDGSLevelEditorSceneViewPanel >> createCamera [
	| scene |
	scene := self scene.
	camera := WDSGCamera new.
	scene add: camera.
	view camera: camera.
	self resetCameraState
]

{ #category : #initialization }
WDGSLevelEditorSceneViewPanel >> createGrid [
	baseGridSize := 10.0.
	primaryGrid := WDSGSpatialObject new
		model: (WDGSLevelEditorElementModel new view: self);
		renderable: self editor primaryGridMesh.
			
	secondaryGrid := WDSGSpatialObject new
		model: (WDGSLevelEditorElementModel new view: self);
		renderable: self editor secondaryGridMesh.
		
	centerAxis := WDSGSpatialObject new
		model: (WDGSLevelEditorElementModel new view: self);
		renderable: self editor centerAxisMesh.

	self scene
		add: secondaryGrid;
		add: primaryGrid;
		add: centerAxis

]

{ #category : #initialization }
WDGSLevelEditorSceneViewPanel >> createSceneView [
	view := WDGSLevelEditorSceneView engine: self engine model: self model.
	view panel: self.
	
	virtualWindow := view openInVirtualWindow.
	virtualWindow extent: self extent asIntegerPoint.
	self mainFrame addSubView: view.
	self editor addLevelView: self.
	self sceneCreated
]

{ #category : #initialization }
WDGSLevelEditorSceneViewPanel >> createSelectionBoxView [
	selectionBoxView := WDGSESelectionBoxView new editor: self editor view: self

	
]

{ #category : #'coordinate systems' }
WDGSLevelEditorSceneViewPanel >> depthAtCameraDistance: distance [
	^ isPerspective
		ifTrue: [ (distance - PerspectiveNearDistance) / (PerspectiveFarDistance - PerspectiveNearDistance) ]
		ifFalse: [ (distance - OrthographicNearDistance) / (OrthographicFarDistance - OrthographicNearDistance) ]
]

{ #category : #accessing }
WDGSLevelEditorSceneViewPanel >> editorViewType [
	^ isPerspective ifTrue: [ #perspective ] ifFalse: [editorViewType]
]

{ #category : #selection }
WDGSLevelEditorSceneViewPanel >> elementsAlongRay: ray do: aBlock [
	selectionBoxView elementsAlongRay: ray do: aBlock.

	^ self editor elementsAlongRay: ray do: aBlock
]

{ #category : #selection }
WDGSLevelEditorSceneViewPanel >> findBestElementAtGlobalCoord: aPosition [
	^ self findBestElementAtWindowCoord: aPosition
]

{ #category : #selection }
WDGSLevelEditorSceneViewPanel >> findBestElementAtWindowCoord: coord [
	| ray bestResult |
	ray := self rayAtWindowCoord: coord.
	bestResult := nil.
	self elementsAlongRay: ray do: [ :result |
		(bestResult isNil or: [ result < bestResult ]) ifTrue: [ 
			bestResult := result
		]
	].

	^ bestResult

]

{ #category : #selection }
WDGSLevelEditorSceneViewPanel >> findElementsAtGlobalCoord: aPosition [
	^ self findElementsAtWindowCoord: aPosition
]

{ #category : #selection }
WDGSLevelEditorSceneViewPanel >> findElementsAtWindowCoord: coord [
	| ray elements|
	ray := self rayAtWindowCoord: coord.
	elements := OrderedCollection new.
	self elementsAlongRay: ray do: [ :result |
		elements add: result
	].

	elements sort: [:a :b | a < b].
	^ elements
]

{ #category : #'view side' }
WDGSLevelEditorSceneViewPanel >> frontView [
	cameraAngle := Float64x3 new.
	gridOrientation := Float32x3x3 lookAtFront.
	editorViewType := #front.
]

{ #category : #'event handling' }
WDGSLevelEditorSceneViewPanel >> handleClick: anEvent [
	| elements currentElement |
	anEvent position = lastDragEndPosition ifTrue: [ 
		lastDragEndPosition := nil.
		^ self
	].

	elements := (self findElementsAtGlobalCoord: anEvent position) collect: #value.
	
	elements ifNotEmpty: [
		lastClickElements = elements ifTrue: [
			(anEvent modifiers ctrl not and: [ anEvent modifiers shift not ]) ifTrue: [ 
				nextClickElementIndex := (nextClickElementIndex + 1) % lastClickElements size
			].
		] ifFalse: [ 
			nextClickElementIndex := 0
		].

		lastClickElements := elements.		
		currentElement := elements at: nextClickElementIndex + 1.
	].

	currentElement := currentElement asNodeModelForLevelEditor: self editor.
	currentElement ifNotNil: [
		(anEvent modifiers ctrl and: [ anEvent modifiers shift not ]) ifTrue: [
			currentElement view: self selectToggleOnEditor: self editor
		].
		(anEvent modifiers ctrl not and: [ anEvent modifiers shift ]) ifTrue: [
			currentElement view: self selectAddOnEditor: self editor
		].
		(anEvent modifiers ctrl not and: [ anEvent modifiers shift not ]) ifTrue: [
			currentElement view: self selectSingleOnEditor: self editor
		]
	] ifNil: [
		(anEvent modifiers ctrl not and: [ anEvent modifiers shift not ]) ifTrue: [ 
			self editor clearSelection
		]
	]
]

{ #category : #'event handling' }
WDGSLevelEditorSceneViewPanel >> handleDragEnd: anEvent [
	lastDragEndPosition := anEvent position.
	toolController ifNotNil: [ toolController onDragEndEvent: anEvent ].
	self releaseMouseWithHost
]

{ #category : #'event handling' }
WDGSLevelEditorSceneViewPanel >> handleDragEvent: anEvent [
	self flag: 'CHECK ME: is this update really needed here?'.
	self updateCameraProjection.
	toolController ifNotNil: [ toolController onDragEvent: anEvent ].
]

{ #category : #'event handling' }
WDGSLevelEditorSceneViewPanel >> handleDragStart: anEvent [
	| element |
	self updateCameraProjection.
	toolController ifNil: [
		anEvent isPrimaryButtonDrag ifTrue: [
			element := (self findBestElementAtGlobalCoord: anEvent position) value asNodeModelForLevelEditor: self editor.
			element ifNil: [
				self editor isFaceSelectMode ifFalse: [
					self startDragController: WDGSEDragMakeSelectionBox new event: anEvent.
				]
			] ifNotNil: [
				self startDragController: (element view: self dragControllerFor: anEvent) event: anEvent.
			]
		].

		anEvent isSecondaryButtonDrag ifTrue: [
			self startDragController: WDGSEDragCameraTranslate new event: anEvent.
		].

		anEvent isMiddleButtonDrag ifTrue: [
			self startDragController: WDGSEDragCameraRotate new event: anEvent.
		].
	].

	toolController ifNotNil: [ toolController onDragStartEvent: anEvent ].
	(toolController isNotNil and: [ toolController needsMouseCapture ]) ifTrue: [ 
		self captureMouseWithHost.
	]
	
]

{ #category : #'event handling' }
WDGSLevelEditorSceneViewPanel >> handleKeyDown: event [
	| keyValue |
	toolController ifNotNil: [ ^ toolController onKeyDownEvent: event ].
	self flag: 'Refactor this into key bindings.'.
	keyValue := event symbol.
	
	(event modifiers cmd or: [ event modifiers ctrl ]) ifTrue: [
		(event modifiers shift not and: [ event modifiers alt ]) ifTrue: [
			keyValue = OSK_s ifTrue: [ self editor saveAs ].
		].

		(event modifiers shift and: [ event modifiers alt not ]) ifTrue: [ 
			keyValue = OSK_p ifTrue: [ self editor addPlayerSpawnPoint: cameraTransform translation ].
		].

		(event modifiers shift and: [ event modifiers alt ]) ifTrue: [ 
			keyValue = OSK_i ifTrue: [ self inspect ]
		].

		(event modifiers shift not and: [ event modifiers alt not]) ifTrue: [ 
			keyValue = OSK_a ifTrue: [ self editor addPointEntity: cameraTransform translation ].
			keyValue = OSK_l ifTrue: [ self editor addLightEntity: cameraTransform translation ].
			keyValue = OSK_g ifTrue: [ self editor addGunItem: cameraTransform translation ].
			keyValue = OSK_b ifTrue: [ self editor makeBrushEntity ].
			
			keyValue = OSK_p ifTrue: [ self editor playInExternalWindow ].
						
			keyValue = OSK_s ifTrue: [ self editor save ].
			keyValue = OSK_o ifTrue: [ self editor fileOpen ].
			"keyValue = OSK_t ifTrue: [ self editor openTextureTransform: self editor ]."
			
			keyValue = OSK_i ifTrue: [ self editor inspectSelection ]
		].
	
	] ifFalse: [ 
		(event modifiers shift not and: [ event modifiers alt not]) ifTrue: [ 
			(keyValue = OSK_MINUS or: [keyValue = OSK_KP_MINUS]) ifTrue: [ self editor subtractSelectedBrushes ].
		
			keyValue = OSK_KP_7 ifTrue: [ self topView ].
			keyValue = OSK_KP_1 ifTrue: [ self frontView ].
			keyValue = OSK_KP_3 ifTrue: [ self sideView ].
			keyValue = OSK_KP_5 ifTrue: [ isPerspective := isPerspective not ].
				
			keyValue = OSK_RETURN ifTrue: [ self editor addObjectAtSelectionCube ].	
			keyValue = OSK_DELETE ifTrue: [ self editor removeSelectedComponents ].
	
			keyValue = OSK_w ifTrue: [ self wireframe ].
			keyValue = OSK_s ifTrue: [ self solid ].
			keyValue = OSK_t ifTrue: [ self textured ].	
				
			keyValue = OSK_f ifTrue: [ self editor toggleFaceSelectMode ].	
		].

		(event modifiers shift not and: [ event modifiers alt ]) ifTrue: [ 
		].

		(event modifiers shift and: [ event modifiers alt not ]) ifTrue: [ 
		].

		(event modifiers shift and: [ event modifiers alt ]) ifTrue: [ 
		].
	].

	super handleKeyDown: event
]

{ #category : #'event handling' }
WDGSLevelEditorSceneViewPanel >> handleKeyUp: event [
	toolController ifNotNil: [ ^ toolController onKeyUpEvent: event ].
	super handleKeyUp: event
]

{ #category : #'event handling' }
WDGSLevelEditorSceneViewPanel >> handleMouseEnter: anEvent [
	self grabKeyboardFocus.
	self editor activeSceneView: self
]

{ #category : #'event handling' }
WDGSLevelEditorSceneViewPanel >> handleMouseMove: anEvent [
	| element |
	super handleMouseMove: anEvent.
	self updateCameraProjection.
	element := (self findBestElementAtGlobalCoord: anEvent position) value asNodeModelForLevelEditor: self editor.
	element
		ifNil: [ self editor mouseOverNone ]
		ifNotNil: [ element view: self mouseOver: anEvent ]
]

{ #category : #'event handling' }
WDGSLevelEditorSceneViewPanel >> handleMouseWheel: event [
	isPerspective ifTrue: [
		cameraTransform translateBy: (cameraTransform matrix transformVector: (Float64x3 z: -0.2*event scrollVertical)).
	] ifFalse: [
		viewScale := viewScale *(1.0 - (event scrollVertical*0.1) max:0.1).
		selectionBoxView ifNotNil: [ selectionBoxView updateNodes ]
]
]

{ #category : #initialization }
WDGSLevelEditorSceneViewPanel >> initialize [
	super initialize.
	viewScale := 3.0.
	self resetCameraState.
	self frontView;
		solid;
		perspective
	
]

{ #category : #accessing }
WDGSLevelEditorSceneViewPanel >> isPerspective [
	^ isPerspective
]

{ #category : #'coordinate systems' }
WDGSLevelEditorSceneViewPanel >> normalizedPosition: aPosition [
	| x y myExtent |
	myExtent := self extent asIntegerPoint.
	
	x := aPosition x / myExtent x.
	y := 1.0 - (aPosition y / myExtent y).
	^ x asFloat @ y
]

{ #category : #'coordinate systems' }
WDGSLevelEditorSceneViewPanel >> normalizedToLocal: aPosition depth: aDepth [
	camera frustum ifNil: [ self updateCameraProjection ].
	^ (camera frustum localPoint: aPosition atDistance: aDepth) asFloat64x3
]

{ #category : #'coordinate systems' }
WDGSLevelEditorSceneViewPanel >> normalizedToWindow: aVector3 [
	| myExtent x y |
	myExtent := self extent asIntegerPoint.
	
	x := myExtent x * aVector3 x.
	y := myExtent y * (1.0 - aVector3 y).
	^ x @ y
]

{ #category : #'coordinate systems' }
WDGSLevelEditorSceneViewPanel >> normalizedToWorld: aPosition depth: aDepth [
	camera frustum ifNil: [ self updateCameraProjection ].
	^ cameraTransform transformPosition: (camera frustum localPoint: aPosition atDistance: aDepth) asFloat64x3
]

{ #category : #'projection mode' }
WDGSLevelEditorSceneViewPanel >> orthographic [
	isPerspective := false.
]

{ #category : #'projection mode' }
WDGSLevelEditorSceneViewPanel >> perspective [
	isPerspective := true.
]

{ #category : #accessing }
WDGSLevelEditorSceneViewPanel >> primaryGridSize [
	^ self editor primaryGridSize
]

{ #category : #selection }
WDGSLevelEditorSceneViewPanel >> rayAtWindowCoord: coord [
	| ray |
	camera frustum ifNil: [ self updateCameraProjection ].
	ray := camera frustum rayAtNormalizedPoint: (self normalizedPosition: coord).
	^ ray asRay3dF64 transformedWith: cameraTransform
]

{ #category : #accessing }
WDGSLevelEditorSceneViewPanel >> renderMode [
	^ renderMode
]

{ #category : #camera }
WDGSLevelEditorSceneViewPanel >> resetCameraState [
	cameraTransform := ReversibleAffineTransform3dF64 identity.
	
	cameraVelocity := Float64x3 new.
	cameraSpeed := 1.0.
	
	cameraAngle := Float64x3 new.
	cameraAngularVelocity := Float64x3 new.
	cameraAngularSpeed := 1.0.

]

{ #category : #utiltity }
WDGSLevelEditorSceneViewPanel >> roundFloor: value quantum: quantum [
	^ ((value / quantum) floor) * quantum
]

{ #category : #initialization }
WDGSLevelEditorSceneViewPanel >> sceneCreated [
	self
		createCamera;
		createGrid;
		createSelectionBoxView

	
]

{ #category : #accessing }
WDGSLevelEditorSceneViewPanel >> selectionBoxView [
	^ selectionBoxView
]

{ #category : #'view side' }
WDGSLevelEditorSceneViewPanel >> sideView [
	cameraAngle := Float64x3 y: Float halfPi.
	gridOrientation := Float32x3x3 lookAtLeft.
	editorViewType := #side.
]

{ #category : #camera }
WDGSLevelEditorSceneViewPanel >> simulateCameraMovement: delta [
	| orientation oldAngle |
	oldAngle := cameraAngle.
	cameraAngle := cameraAngle + (cameraAngularVelocity * (cameraAngularSpeed * delta)).
	(oldAngle closeTo: cameraAngle) ifFalse: [ 	editorViewType := #rotated. ].
	orientation := (Float64x3x3 yRotation: cameraAngle y) * (Float64x3x3 xRotation: cameraAngle x).

	cameraTransform
		orthonormal: orientation;
		translateBy: orientation * (cameraVelocity * (cameraSpeed * delta)).

]

{ #category : #snapping }
WDGSLevelEditorSceneViewPanel >> snapBox: box [
	^ self editor snapBox: box
]

{ #category : #snapping }
WDGSLevelEditorSceneViewPanel >> snapTranslation: translation [
	^ self editor snapTranslation: translation
]

{ #category : #'rendering mode' }
WDGSLevelEditorSceneViewPanel >> solid [
	renderMode := #solid
]

{ #category : #'event handling' }
WDGSLevelEditorSceneViewPanel >> startDragController: aDrawToolController event: anEvent [
	aDrawToolController ifNotNil: [
		aDrawToolController view: self.
	].

	self toolController: aDrawToolController.
]

{ #category : #'rendering mode' }
WDGSLevelEditorSceneViewPanel >> textured [
	renderMode := #textured
]

{ #category : #'projection mode' }
WDGSLevelEditorSceneViewPanel >> togglePerspective [
	isPerspective := isPerspective not
]

{ #category : #accessing }
WDGSLevelEditorSceneViewPanel >> toolController [
	^ toolController
]

{ #category : #accessing }
WDGSLevelEditorSceneViewPanel >> toolController: aToolController [
	toolController := aToolController
]

{ #category : #'event handling' }
WDGSLevelEditorSceneViewPanel >> toolControllerFinished [
	self toolController: nil
]

{ #category : #'view side' }
WDGSLevelEditorSceneViewPanel >> topView [
	cameraAngle := Float64x3 x: Float halfPi negated.
	gridOrientation := Float32x3x3 lookAtBottom.
	editorViewType := #top.
]

{ #category : #camera }
WDGSLevelEditorSceneViewPanel >> updateCameraProjection [
	camera isPerspective: isPerspective.
	camera focalDistance: (viewScale / ((camera fieldOfView * 0.5) degreesToRadians tan)).
	isPerspective ifTrue: [
		camera nearDistance: PerspectiveNearDistance; farDistance: PerspectiveFarDistance
	] ifFalse: [
		camera nearDistance: OrthographicNearDistance; farDistance: OrthographicFarDistance.
	]
]

{ #category : #camera }
WDGSLevelEditorSceneViewPanel >> updateCameraStateForRendering [
	self
		updateCameraProjection;
		updateGridTransform.
	camera transform: cameraTransform
]

{ #category : #grid }
WDGSLevelEditorSceneViewPanel >> updateGridTransform [
	| orientation scale renderPriority u v cameraTranslation du dv translation |
	orientation := isPerspective ifTrue: [ Float32x3x3 lookAtBottom ] ifFalse: [ gridOrientation ].
	renderPriority := isPerspective
		ifTrue: [ WDSGNode renderPriorityEditorOpaqueAfter ]
		ifFalse: [ WDSGNode renderPriorityEditorOpaqueBefore ].
		
	scale := self editor primaryGridSize / baseGridSize.
	u := orientation firstRow asFloat64x3.
	v := orientation secondRow asFloat64x3.
	
	cameraTranslation := cameraTransform translation.
	du := self roundFloor: (u dot: cameraTranslation) quantum: self primaryGridSize.
	dv := self roundFloor: (v dot: cameraTranslation) quantum: self primaryGridSize.
	
	translation := (u * du) + (v * dv).
	
	primaryGrid renderPriority: renderPriority + 1.
	primaryGrid transform
		setIdentity;
		orthonormal: orientation;
		scaleByX: scale y: scale z: scale;
		translation: translation asFloat32x3.
		
	secondaryGrid renderPriority: renderPriority.
	secondaryGrid transform
		setIdentity;
		orthonormal: orientation;
		scaleByX: scale y: scale z: scale;
		translation: translation asFloat32x3.
		
	centerAxis renderPriority: renderPriority + 2.
]

{ #category : #accessing }
WDGSLevelEditorSceneViewPanel >> viewScale [
	^ viewScale
]

{ #category : #accessing }
WDGSLevelEditorSceneViewPanel >> viewScaleFactor [
	^ viewScale / 3.0
]

{ #category : #'coordinate systems' }
WDGSLevelEditorSceneViewPanel >> windowGlobalToLocal: aPosition depth: aDepth [
	^ self windowToLocal: aPosition depth: aDepth
]

{ #category : #'coordinate systems' }
WDGSLevelEditorSceneViewPanel >> windowGlobalToWorld: aPosition depth: aDepth [
	^ self windowToWorld: aPosition depth: aDepth
]

{ #category : #'coordinate systems' }
WDGSLevelEditorSceneViewPanel >> windowToLocal: aPosition depth: aDepth [
	^ self normalizedToLocal: (self normalizedPosition: aPosition) depth: aDepth
]

{ #category : #'coordinate systems' }
WDGSLevelEditorSceneViewPanel >> windowToWorld: aPosition depth: aDepth [
	^ self normalizedToWorld: (self normalizedPosition: aPosition) depth: aDepth
]

{ #category : #'rendering mode' }
WDGSLevelEditorSceneViewPanel >> wireframe [
	renderMode := #wire
]

{ #category : #'coordinate systems' }
WDGSLevelEditorSceneViewPanel >> worldToWindow: aPoint [
	^ self normalizedToWindow: (camera frustum localToNormalized: (cameraTransform inverseTransformPosition3: aPoint) asFloat32x3)
]

{ #category : #'coordinate systems' }
WDGSLevelEditorSceneViewPanel >> xDragDirection [
	^ cameraTransform matrix firstColumn
]

{ #category : #'coordinate systems' }
WDGSLevelEditorSceneViewPanel >> xyDragDirection [
	^ self xDragDirection + self yDragDirection
]

{ #category : #'coordinate systems' }
WDGSLevelEditorSceneViewPanel >> yDragDirection [
	^ cameraTransform matrix secondColumn
]

{ #category : #'coordinate systems' }
WDGSLevelEditorSceneViewPanel >> zBackwardDirection [
	^ cameraTransform matrix thirdColumn
]

{ #category : #'coordinate systems' }
WDGSLevelEditorSceneViewPanel >> zDragDirection [
	^ cameraTransform matrix thirdColumn negated
]
