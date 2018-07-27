Class {
	#name : #WTGLevelEditorView,
	#superclass : #WTGLevelEditorViewComponent,
	#instVars : [
		'camera',
		'cameraVelocity',
		'cameraSpeed',
		'cameraAngle',
		'cameraAngularVelocity',
		'cameraAngularSpeed',
		'renderMode',
		'cameraTransform',
		'baseGridSize',
		'primaryGrid',
		'secondaryGrid',
		'gridOrientation',
		'isPerspective',
		'cameraFrustum',
		'toolController',
		'lastClickElements',
		'nextClickElementIndex',
		'centerAxis',
		'lastDragEndPosition',
		'selectionBoxView',
		'viewScale'
	],
	#classVars : [
		'OrthographicFarDistance',
		'OrthographicNearDistance',
		'PerspectiveFarDistance',
		'PerspectiveNearDistance'
	],
	#category : #'WodenEngine-LevelEditor-Old'
}

{ #category : #'class initialization' }
WTGLevelEditorView class >> initialize [
	super initialize.
	PerspectiveNearDistance := 0.01.
	PerspectiveFarDistance := 10000.0.
	
	OrthographicNearDistance := -10000.0.
	OrthographicFarDistance := OrthographicNearDistance negated.

]

{ #category : #accessing }
WTGLevelEditorView >> camera [
	^ camera
]

{ #category : #accessing }
WTGLevelEditorView >> cameraAngle [
	^ cameraAngle
]

{ #category : #accessing }
WTGLevelEditorView >> cameraAngle: anEulerAngle [
	cameraAngle := anEulerAngle
]

{ #category : #accessing }
WTGLevelEditorView >> cameraTransform [
	^ cameraTransform
]

{ #category : #'as yet unclassified' }
WTGLevelEditorView >> computeAspectRatio [
	| myExtent |
	myExtent := self innerBounds extent.
	(myExtent y asFloat closeTo: 0.0) ifTrue: [ ^ 1.0 ].
	^ myExtent x asFloat / myExtent y asFloat
]

{ #category : #'as yet unclassified' }
WTGLevelEditorView >> createCamera [
	| scene |
	scene := self scene.
	
	camera := WDSGCamera new.
	scene add: camera.
	
	self resetCameraState.

]

{ #category : #'as yet unclassified' }
WTGLevelEditorView >> createGrid [
	baseGridSize := 10.0.
	primaryGrid := WDSGSpatialObject new
		model: (WTGLevelEditorElementModel new view: self);
		renderable: editor primaryGridMesh.
			
	secondaryGrid := WDSGSpatialObject new
		model: (WTGLevelEditorElementModel new view: self);
		renderable: editor secondaryGridMesh.
		
	centerAxis := WDSGSpatialObject new
		model: (WTGLevelEditorElementModel new view: self);
		renderable: editor centerAxisMesh.

	self scene
		add: secondaryGrid;
		add: primaryGrid;
		add: centerAxis

]

{ #category : #'initialize-release' }
WTGLevelEditorView >> createSelectionBoxView [
	selectionBoxView := WTGESelectionBoxView new editor: editor view: self.
]

{ #category : #'coordinate systems' }
WTGLevelEditorView >> depthAtCameraDistance: distance [
	^ isPerspective
		ifTrue: [ (distance - PerspectiveNearDistance) / (PerspectiveFarDistance - PerspectiveNearDistance) ]
		ifFalse: [ (distance - OrthographicNearDistance) / (OrthographicFarDistance - OrthographicNearDistance) ]
]

{ #category : #selection }
WTGLevelEditorView >> elementsAlongRay: ray do: aBlock [
	selectionBoxView elementsAlongRay: ray do: aBlock.

	^ editor elementsAlongRay: ray do: aBlock
]

{ #category : #selection }
WTGLevelEditorView >> findBestElementAtGlobalCoord: aPosition [
	^ self findBestElementAtWindowCoord: (self globalPointToLocal: aPosition)
]

{ #category : #selection }
WTGLevelEditorView >> findBestElementAtWindowCoord: coord [
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
WTGLevelEditorView >> findElementsAtGlobalCoord: aPosition [
	^ self findElementsAtWindowCoord: (self globalPointToLocal: aPosition)
]

{ #category : #selection }
WTGLevelEditorView >> findElementsAtWindowCoord: coord [
	| ray elements|
	ray := self rayAtWindowCoord: coord.
	elements := OrderedCollection new.
	self elementsAlongRay: ray do: [ :result |
		elements add: result
	].

	elements sort: [:a :b | a < b].
	^ elements
]

{ #category : #'event handling' }
WTGLevelEditorView >> fpsModeOnKeyDownEvent: anEvent [
	| keyValue |
	keyValue := anEvent keyValue.
	keyValue = OSK_a ifTrue: [ cameraVelocity x: -1.0 ].
	keyValue = OSK_d ifTrue: [ cameraVelocity x: 1.0 ].
	keyValue = OSK_w ifTrue: [ cameraVelocity z: -1.0 ].
	keyValue = OSK_s ifTrue: [ cameraVelocity z: 1.0 ].
	keyValue = OSK_LCTRL ifTrue: [ cameraVelocity y: -1.0 ].
	keyValue = OSK_SPACE ifTrue: [ cameraVelocity y: 1.0 ].

	keyValue = OSK_UP ifTrue: [ cameraAngularVelocity x: 1.0 ].
	keyValue = OSK_DOWN ifTrue: [ cameraAngularVelocity x: -1.0 ].
	keyValue = OSK_LEFT ifTrue: [ cameraAngularVelocity y: 1.0 ].
	keyValue = OSK_RIGHT ifTrue: [ cameraAngularVelocity y: -1.0 ].
	
	keyValue = OSK_LSHIFT ifTrue: [ cameraSpeed := 3.0 ].
	
	((anEvent buttons anyMask: 2r01000000) and: [ keyValue = OSK_i ]) ifTrue: [ self inspect ].
]

{ #category : #'event handling' }
WTGLevelEditorView >> fpsModeOnKeyUpEvent: anEvent [
	| keyValue |
	keyValue := anEvent keyValue.
	keyValue = OSK_a ifTrue: [ cameraVelocity x < 0 ifTrue: [ cameraVelocity x: 0.0 ] ].
	keyValue = OSK_d ifTrue: [ cameraVelocity x > 0 ifTrue: [ cameraVelocity x: 0.0 ] ].
	keyValue = OSK_w ifTrue: [ cameraVelocity z < 0 ifTrue: [ cameraVelocity z: 0.0 ] ].
	keyValue = OSK_s ifTrue: [ cameraVelocity z > 0 ifTrue: [ cameraVelocity z: 0.0 ] ].

	keyValue = OSK_UP ifTrue: [ cameraAngularVelocity x > 0 ifTrue: [ cameraAngularVelocity x: 0.0 ] ].
	keyValue = OSK_DOWN ifTrue: [ cameraAngularVelocity x < 0 ifTrue: [ cameraAngularVelocity x: 0.0 ] ].
	keyValue = OSK_LEFT ifTrue: [ cameraAngularVelocity y > 0 ifTrue: [ cameraAngularVelocity y: 0.0 ] ].
	keyValue = OSK_RIGHT ifTrue: [ cameraAngularVelocity y < 0 ifTrue: [ cameraAngularVelocity y: 0.0 ] ].
	
	keyValue = OSK_LCTRL ifTrue: [ cameraVelocity y < 0 ifTrue: [ cameraVelocity y: 0.0 ] ].
	keyValue = OSK_SPACE ifTrue: [ cameraVelocity y > 0 ifTrue: [ cameraVelocity y: 0.0 ] ].
	keyValue = OSK_LSHIFT ifTrue: [ cameraSpeed := 1.0 ].
]

{ #category : #'view side' }
WTGLevelEditorView >> frontView [
	cameraAngle := WMVector3D new.
	gridOrientation := WMMatrix3F lookAtFront.
]

{ #category : #'initialize-release' }
WTGLevelEditorView >> initialize [
	super initialize.
	viewScale := 3.0.
	self resetCameraState.
	self initializeHandlers.
	self frontView;
		solid;
		perspective
]

{ #category : #'event handling' }
WTGLevelEditorView >> initializeHandlers [
	self
		addEventHandler: (BlEventHandler on: BlMouseEnterEvent do: [ :evt | 
			evt consumed: true.
			self requestFocus.
		]);
		addEventHandler: (BlEventHandler on: BlClickEvent do: [ :evt | 
			evt consumed: true.
			self onClickEvent: evt.
		]);
		addEventHandler: (BlEventHandler on: BlDblClickEvent do: [ :evt | 
			evt consumed: true.
			self onDoubleClickEvent: evt.
		]);
		addEventHandler: (BlEventHandler on: BlMouseMoveEvent do: [ :evt | 
			self onMouseMoveEvent: evt.
		]);
		addEventHandler: (BlEventHandler on: BlScrollEvent do: [ :evt | 
			self onScrollEvent: evt.
		]);
		addEventHandler: (BlEventHandler on: BlDragStartEvent do: [ :evt | 
			evt consumed: true.
			self onDragStartEvent: evt.
		]);
		addEventHandler: (BlEventHandler on: BlDragEvent do: [ :evt | 
			evt consumed: true.
			self onDragEvent: evt.
		]);	
		addEventHandler: (BlEventHandler on: BlDragEndEvent do: [ :evt | 
			evt consumed: true.
			self onDragEndEvent: evt.
		]);
		addEventHandler: (BlEventHandler on: BlDropEvent do: [ :evt | 
			evt consumed: true.
			self onDropEvent: evt.
		]);
		addEventHandler: (BlEventHandler on: BlTextInputEvent do: [ :evt | 
			evt consumed: true.
			self onTextInput: evt.
		]);
		addEventHandler: (BlEventHandler on: BlKeyDownEvent do: [ :evt | 
			evt consumed: true.
			self onKeyDownEvent: evt.
		]);
		addEventHandler: (BlEventHandler on: BlKeyUpEvent do: [ :evt | 
			evt consumed: true.
			self onKeyUpEvent: evt.
		])

]

{ #category : #accessing }
WTGLevelEditorView >> isPerspective [
	^ isPerspective
]

{ #category : #'coordinate systems' }
WTGLevelEditorView >> normalizedPosition: aPosition [
	| x y myExtent |
	myExtent := self innerBounds extent.
	
	x := aPosition x / myExtent x.
	y := 1.0 - (aPosition y / myExtent y).
	^ x asFloat @ y
]

{ #category : #'coordinate systems' }
WTGLevelEditorView >> normalizedToLocal: aPosition depth: aDepth [
	cameraFrustum ifNil: [ self updateCameraProjection ].
	^ (cameraFrustum localPoint: aPosition atDistance: aDepth) asWMVector3D
]

{ #category : #'coordinate systems' }
WTGLevelEditorView >> normalizedToWindow: aVector3 [
	| myExtent x y |
	myExtent := self innerBounds extent.
	
	x := myExtent x * aVector3 x.
	y := myExtent y * (1.0 - aVector3 y).
	^ x @ y
]

{ #category : #'coordinate systems' }
WTGLevelEditorView >> normalizedToWorld: aPosition depth: aDepth [
	cameraFrustum ifNil: [ self updateCameraProjection ].
	^ cameraTransform transformPosition3: (cameraFrustum localPoint: aPosition atDistance: aDepth) asWMVector3D
]

{ #category : #'event handling' }
WTGLevelEditorView >> onClickEvent: anEvent [
	| elements currentElement |
	anEvent position = lastDragEndPosition ifTrue: [ 
		lastDragEndPosition := nil.
		^ self
	].

	elements := (self findElementsAtGlobalCoord: anEvent position) collect: #value.
	
	elements ifNotEmpty: [
		lastClickElements = elements ifTrue: [
			(anEvent modifiers isCtrl not and: [ anEvent modifiers isShift not ]) ifTrue: [ 
				nextClickElementIndex := (nextClickElementIndex + 1) % lastClickElements size
			].
		] ifFalse: [ 
			nextClickElementIndex := 0
		].

		lastClickElements := elements.		
		currentElement := elements at: nextClickElementIndex + 1.
	].

	currentElement := currentElement asNodeModelForLevelEditor: editor.
	currentElement ifNotNil: [
		(anEvent modifiers isCtrl and: [ anEvent modifiers isShift not ]) ifTrue: [
			currentElement view: self selectToggleOnEditor: editor
		].
		(anEvent modifiers isCtrl not and: [ anEvent modifiers isShift ]) ifTrue: [
			currentElement view: self selectAddOnEditor: editor
		].
		(anEvent modifiers isCtrl not and: [ anEvent modifiers isShift not ]) ifTrue: [
			currentElement view: self selectSingleOnEditor: editor
		]
	] ifNil: [
		(anEvent modifiers isCtrl not and: [ anEvent modifiers isShift not ]) ifTrue: [ 
			editor clearSelection
		]
	]
]

{ #category : #'event handling' }
WTGLevelEditorView >> onDoubleClickEvent: anEvent [
]

{ #category : #'event handling' }
WTGLevelEditorView >> onDragEndEvent: anEvent [
	lastDragEndPosition := anEvent position.
	toolController ifNotNil: [ toolController onDragEndEvent: anEvent ].
	editor releaseMouse
]

{ #category : #'event handling' }
WTGLevelEditorView >> onDragEvent: anEvent [
	self updateCameraProjection.
	toolController ifNotNil: [ toolController onDragEvent: anEvent ].
]

{ #category : #'event handling' }
WTGLevelEditorView >> onDragStartEvent: anEvent [
	| element |
	self updateCameraProjection.
	toolController ifNil: [
		anEvent isPrimaryButtonDrag ifTrue: [
			element := (self findBestElementAtGlobalCoord: anEvent position) value asNodeModelForLevelEditor: editor.
			element ifNil: [
				editor isFaceSelectMode ifFalse: [
					self startDragController: WTGEDragMakeSelectionBox new event: anEvent.
				]
			] ifNotNil: [
				self startDragController: (element view: self dragControllerFor: anEvent) event: anEvent.
			]
		].

		anEvent isSecondaryButtonDrag ifTrue: [
			self startDragController: WTGEDragCameraTranslate new event: anEvent.
		].

		anEvent isMiddleButtonDrag ifTrue: [
			self startDragController: WTGEDragCameraRotate new event: anEvent.
		].
	].

	toolController ifNotNil: [ toolController onDragStartEvent: anEvent ].
	(toolController isNotNil and: [ toolController needsMouseCapture ]) ifTrue: [ 
		editor captureMouse.
	]
	
]

{ #category : #'event handling' }
WTGLevelEditorView >> onDropEvent: event [
	"Transcript show: event; cr."
]

{ #category : #'event handling' }
WTGLevelEditorView >> onKeyDownEvent: anEvent [
	| keyValue |
	toolController ifNotNil: [ ^ toolController onKeyDownEvent: anEvent ].
	keyValue := anEvent keyValue.

	(anEvent modifiers isCmd or: [ anEvent modifiers isCtrl ]) ifTrue: [
		(anEvent modifiers isShift not and: [ anEvent modifiers isAlt ]) ifTrue: [
			keyValue = OSK_s ifTrue: [ editor saveAs ].
		].

		(anEvent modifiers isShift and: [ anEvent modifiers isAlt not ]) ifTrue: [ 
			keyValue = OSK_p ifTrue: [ editor addPlayerSpawnPoint: cameraTransform translation ].
		].

		(anEvent modifiers isShift and: [ anEvent modifiers isAlt ]) ifTrue: [ 
			keyValue = OSK_i ifTrue: [ self inspect ]
		].

		(anEvent modifiers isShift not and: [ anEvent modifiers isAlt not]) ifTrue: [ 
			keyValue = OSK_a ifTrue: [ editor addPointEntity: cameraTransform translation ].
			keyValue = OSK_l ifTrue: [ editor addLightEntity: cameraTransform translation ].
			keyValue = OSK_g ifTrue: [ editor addGunItem: cameraTransform translation ].
			keyValue = OSK_b ifTrue: [ editor makeBrushEntity ].
			
			keyValue = OSK_p ifTrue: [ editor playInExternalWindow ].
						
			keyValue = OSK_s ifTrue: [ editor save ].
			keyValue = OSK_o ifTrue: [ editor open ].
			keyValue = OSK_t ifTrue: [ editor openTextureTransformEditor ].
			
			keyValue = OSK_i ifTrue: [ editor inspectSelection ]
		].
	
	] ifFalse: [ 
		(anEvent modifiers isShift not and: [ anEvent modifiers isAlt not]) ifTrue: [ 
			(keyValue = OSK_MINUS or: [keyValue = OSK_KP_MINUS]) ifTrue: [ editor subtractSelectedBrushes ].
		
			keyValue = OSK_KP_7 ifTrue: [ self topView ].
			keyValue = OSK_KP_1 ifTrue: [ self frontView ].
			keyValue = OSK_KP_3 ifTrue: [ self sideView ].
			keyValue = OSK_KP_5 ifTrue: [ isPerspective := isPerspective not ].
				
			keyValue = OSK_RETURN ifTrue: [ editor addCubeBrushAtSelectionCube ].	
			keyValue = OSK_DELETE ifTrue: [ editor removeSelectedComponents ].
	
			keyValue = OSK_w ifTrue: [ self wireframe ].
			keyValue = OSK_s ifTrue: [ self solid ].
			keyValue = OSK_t ifTrue: [ self textured ].	
				
			keyValue = OSK_f ifTrue: [ editor toggleFaceSelectMode ].	
		].

		(anEvent modifiers isShift not and: [ anEvent modifiers isAlt ]) ifTrue: [ 
		].

		(anEvent modifiers isShift and: [ anEvent modifiers isAlt not ]) ifTrue: [ 
		].

		(anEvent modifiers isShift and: [ anEvent modifiers isAlt ]) ifTrue: [ 
		].
	]
]

{ #category : #'event handling' }
WTGLevelEditorView >> onKeyUpEvent: anEvent [
	| keyValue |
	toolController ifNotNil: [ ^ toolController onKeyUpEvent: anEvent ].
	keyValue := anEvent keyValue.
	
	keyValue = OSK_a ifTrue: [ cameraVelocity := WMVector3D x: 0.0 ].
]

{ #category : #'event handling' }
WTGLevelEditorView >> onMouseMoveEvent: anEvent [
	| element |
	self updateCameraProjection.
	element := (self findBestElementAtGlobalCoord: anEvent position) value asNodeModelForLevelEditor: editor.
	element
		ifNil: [ editor mouseOverNone ]
		ifNotNil: [ element view: self mouseOver: anEvent ]
]

{ #category : #'event handling' }
WTGLevelEditorView >> onScrollEvent: event [
	isPerspective ifTrue: [
		event direction = Character arrowUp ifTrue: [ 
			cameraTransform translateByZ: -0.2.
		].
		event direction = Character arrowDown ifTrue: [ 
			cameraTransform translateByZ: 0.2.
		].
	] ifFalse: [
		event direction = Character arrowUp ifTrue: [ 
			viewScale := viewScale * 0.8.
		].
		event direction = Character arrowDown ifTrue: [ 
			viewScale := viewScale * 1.2.
		].
		selectionBoxView ifNotNil: [ selectionBoxView updateNodes ]
	]
]

{ #category : #'event handling' }
WTGLevelEditorView >> onTextInput: anEvent [
	toolController ifNotNil: [ ^ toolController onTextInput: anEvent ].
]

{ #category : #'projection mode' }
WTGLevelEditorView >> orthographic [
	isPerspective := false.
]

{ #category : #'projection mode' }
WTGLevelEditorView >> perspective [
	isPerspective := true.
]

{ #category : #accessing }
WTGLevelEditorView >> primaryGridSize [
	^ editor primaryGridSize
]

{ #category : #selection }
WTGLevelEditorView >> rayAtWindowCoord: coord [
	| ray |
	cameraFrustum ifNil: [ self updateCameraProjection ].
	ray := cameraFrustum rayAtNormalizedPoint: (self normalizedPosition: coord).
	^ ray asWMRayD transformedWith: cameraTransform
]

{ #category : #'as yet unclassified' }
WTGLevelEditorView >> resetCameraState [
	cameraTransform := WMReversibleAffineTransformD new.
	
	cameraVelocity := WMVector3D new.
	cameraSpeed := 1.0.
	
	cameraAngle := WMVector3D new.
	cameraAngularVelocity := WMVector3D new.
	cameraAngularSpeed := 1.0.

]

{ #category : #utiltity }
WTGLevelEditorView >> roundFloor: value quantum: quantum [
	^ ((value / quantum) floor) * quantum
]

{ #category : #utiltity }
WTGLevelEditorView >> roundToGrid: value [
	^ editor roundToGrid: value
]

{ #category : #'as yet unclassified' }
WTGLevelEditorView >> sceneCreated [
	self
		createCamera;
		createGrid;
		createSelectionBoxView
]

{ #category : #accessing }
WTGLevelEditorView >> secondaryGridSize [
	^ editor secondaryGridSize
]

{ #category : #accessing }
WTGLevelEditorView >> selectionBoxView [
	^ selectionBoxView
]

{ #category : #'view side' }
WTGLevelEditorView >> sideView [
	cameraAngle := WMVector3D y: Float halfPi.
	gridOrientation := WMMatrix3F lookAtLeft.
]

{ #category : #'as yet unclassified' }
WTGLevelEditorView >> simulateCameraMovement: delta [
	| orientation |
	cameraAngle := cameraAngle + (cameraAngularVelocity * (cameraAngularSpeed * delta)).
	orientation := (WMMatrix3D yrot: cameraAngle y) * (WMMatrix3D xrot: cameraAngle x).

	cameraTransform
		orthonormal: orientation;
		translateBy: (orientation transformVector3: (cameraVelocity * (cameraSpeed * delta))).

]

{ #category : #'as yet unclassified' }
WTGLevelEditorView >> snapBox: box [
	^ editor snapBox: box
]

{ #category : #'as yet unclassified' }
WTGLevelEditorView >> snapTranslation: translation [
	^ editor snapTranslation: translation
]

{ #category : #'rendering mode' }
WTGLevelEditorView >> solid [
	renderMode := #solid
]

{ #category : #'event handling' }
WTGLevelEditorView >> startDragController: aDrawToolController event: anEvent [
	aDrawToolController ifNotNil: [
		aDrawToolController view: self.
	].

	self toolController: aDrawToolController.
]

{ #category : #'rendering mode' }
WTGLevelEditorView >> textured [
	renderMode := #textured
]

{ #category : #'projection mode' }
WTGLevelEditorView >> togglePerspective [
	isPerspective := isPerspective not
]

{ #category : #accessing }
WTGLevelEditorView >> toolController [
	^ toolController
]

{ #category : #accessing }
WTGLevelEditorView >> toolController: aToolController [
	toolController := aToolController
]

{ #category : #'tool controllers' }
WTGLevelEditorView >> toolControllerFinished [
	self toolController: nil
]

{ #category : #'view side' }
WTGLevelEditorView >> topView [
	cameraAngle := WMVector3D x: Float halfPi negated.
	gridOrientation := WMMatrix3F lookAtBottom.
]

{ #category : #'as yet unclassified' }
WTGLevelEditorView >> updateCameraProjection [
	| aspect h w |
	aspect := self computeAspectRatio.
	cameraFrustum := WMFrustumF new.
	isPerspective ifTrue: [
		cameraFrustum reverseDepthPerspectiveFovY: 60.0 aspect: aspect near: PerspectiveNearDistance far: PerspectiveFarDistance invertedY: editor engine projectionInvertedY.
	] ifFalse: [
		h := viewScale.
		w := h * aspect.
		cameraFrustum reverseDepthOrthoLeft: w negated right: w bottom: h negated top: h near: OrthographicNearDistance far: OrthographicFarDistance invertedY: editor engine projectionInvertedY.
	].

	camera state 
		projectionMatrix: cameraFrustum matrix.
]

{ #category : #'as yet unclassified' }
WTGLevelEditorView >> updateCameraStateForRendering [
	self
		updateCameraProjection;
		updateGridTransform.
	camera transform: cameraTransform.
]

{ #category : #'as yet unclassified' }
WTGLevelEditorView >> updateGridTransform [
	| orientation scale renderPriority u v cameraTranslation du dv translation |
	orientation := isPerspective ifTrue: [ WMMatrix3F lookAtBottom ] ifFalse: [ gridOrientation ].
	renderPriority := isPerspective
		ifTrue: [ WDSGNode renderPriorityEditorOpaqueAfter ]
		ifFalse: [ WDSGNode renderPriorityEditorOpaqueBefore ].
		
	scale := editor primaryGridSize / baseGridSize.
	u := orientation firstRow asWMVector3D.
	v := orientation secondRow asWMVector3D.
	
	cameraTranslation := cameraTransform translation.
	du := self roundFloor: (u dot: cameraTranslation) quantum: self primaryGridSize.
	dv := self roundFloor: (v dot: cameraTranslation) quantum: self primaryGridSize.
	
	translation := (u * du) + (v * dv).
	
	primaryGrid renderPriority: renderPriority + 1.
	primaryGrid transform
		setIdentity;
		orthonormal: orientation;
		scaleByX: scale y: scale z: scale;
		translation: translation asWMVector3F.
		
	secondaryGrid renderPriority: renderPriority.
	secondaryGrid transform
		setIdentity;
		orthonormal: orientation;
		scaleByX: scale y: scale z: scale;
		translation: translation asWMVector3F.
		
	centerAxis renderPriority: renderPriority + 2.
]

{ #category : #accessing }
WTGLevelEditorView >> viewScale [
	^ viewScale
]

{ #category : #accessing }
WTGLevelEditorView >> viewScaleFactor [
	^ viewScale / 3.0
]

{ #category : #accessing }
WTGLevelEditorView >> viewport [
	^ WDSGViewport new
		bounds: self innerBoundsInSpace;
		camera: camera;
		submode: renderMode;
		filter: [ :object | object model isNil or: [ object model visibleForView: self ] ];
		yourself
]

{ #category : #'coordinate systems' }
WTGLevelEditorView >> windowGlobalToLocal: aPosition depth: aDepth [
	^ self windowToLocal: (self globalPointToLocal: aPosition) depth: aDepth
]

{ #category : #'coordinate systems' }
WTGLevelEditorView >> windowGlobalToWorld: aPosition depth: aDepth [
	^ self windowToWorld: (self globalPointToLocal: aPosition) depth: aDepth
]

{ #category : #'coordinate systems' }
WTGLevelEditorView >> windowToLocal: aPosition depth: aDepth [
	^ self normalizedToLocal: (self normalizedPosition: aPosition) depth: aDepth
]

{ #category : #'coordinate systems' }
WTGLevelEditorView >> windowToWorld: aPosition depth: aDepth [
	^ self normalizedToWorld: (self normalizedPosition: aPosition) depth: aDepth
]

{ #category : #'rendering mode' }
WTGLevelEditorView >> wireframe [
	renderMode := #wire
]

{ #category : #'coordinate systems' }
WTGLevelEditorView >> worldToWindow: aPoint [
	^ self normalizedToWindow: (cameraFrustum localToNormalized: (cameraTransform inverseTransformPosition3: aPoint) asWMVector3F)
]

{ #category : #'coordinate systems' }
WTGLevelEditorView >> xDragDirection [
	^ cameraTransform matrix firstColumn
]

{ #category : #'coordinate systems' }
WTGLevelEditorView >> xyDragDirection [
	^ self xDragDirection + self yDragDirection
]

{ #category : #'coordinate systems' }
WTGLevelEditorView >> yDragDirection [
	^ cameraTransform matrix secondColumn
]

{ #category : #'coordinate systems' }
WTGLevelEditorView >> zBackwardDirection [
	^ cameraTransform matrix thirdColumn
]

{ #category : #'coordinate systems' }
WTGLevelEditorView >> zDragDirection [
	^ cameraTransform matrix thirdColumn negated
]
