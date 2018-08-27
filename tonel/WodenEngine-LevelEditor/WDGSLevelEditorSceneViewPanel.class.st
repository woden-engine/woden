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
		'cameraFrustum'
	],
	#classVars : [
		'OrthographicFarDistance',
		'OrthographicNearDistance',
		'PerspectiveFarDistance',
		'PerspectiveNearDistance'
	],
	#category : #'WodenEngine-LevelEditor-View'
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
WDGSLevelEditorSceneViewPanel >> cameraTransform [
	^ cameraTransform
]

{ #category : #'as yet unclassified' }
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
		model: (WTGLevelEditorElementModel new view: self);
		renderable: self editor primaryGridMesh.
			
	secondaryGrid := WDSGSpatialObject new
		model: (WTGLevelEditorElementModel new view: self);
		renderable: self editor secondaryGridMesh.
		
	centerAxis := WDSGSpatialObject new
		model: (WTGLevelEditorElementModel new view: self);
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
	selectionBoxView := WTGESelectionBoxView new editor: self editor view: self

	
]

{ #category : #'view side' }
WDGSLevelEditorSceneViewPanel >> frontView [
	cameraAngle := WMVector3D new.
	gridOrientation := WMMatrix3F lookAtFront.
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

{ #category : #'as yet unclassified' }
WDGSLevelEditorSceneViewPanel >> resetCameraState [
	cameraTransform := WMReversibleAffineTransformD identity.
	
	cameraVelocity := WMVector3D new.
	cameraSpeed := 1.0.
	
	cameraAngle := WMVector3D new.
	cameraAngularVelocity := WMVector3D new.
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
	cameraAngle := WMVector3D y: Float halfPi.
	gridOrientation := WMMatrix3F lookAtLeft.
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorSceneViewPanel >> simulateCameraMovement: delta [
	| orientation |
	cameraAngle := cameraAngle + (cameraAngularVelocity * (cameraAngularSpeed * delta)).
	orientation := (WMMatrix3D yrot: cameraAngle y) * (WMMatrix3D xrot: cameraAngle x).

	cameraTransform
		orthonormal: orientation;
		translateBy: (orientation transformVector3: (cameraVelocity * (cameraSpeed * delta))).

]

{ #category : #'rendering mode' }
WDGSLevelEditorSceneViewPanel >> solid [
	renderMode := #solid
]

{ #category : #'rendering mode' }
WDGSLevelEditorSceneViewPanel >> textured [
	renderMode := #textured
]

{ #category : #'projection mode' }
WDGSLevelEditorSceneViewPanel >> togglePerspective [
	isPerspective := isPerspective not
]

{ #category : #'view side' }
WDGSLevelEditorSceneViewPanel >> topView [
	cameraAngle := WMVector3D x: Float halfPi negated.
	gridOrientation := WMMatrix3F lookAtBottom.
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorSceneViewPanel >> updateCameraProjection [
	camera isPerspective: isPerspective.
	camera focalDistance: (viewScale / ((camera fieldOfView * 0.5) degreesToRadians tan)).
	isPerspective ifTrue: [
		camera nearDistance: PerspectiveNearDistance; farDistance: PerspectiveFarDistance
	] ifFalse: [
		camera nearDistance: OrthographicNearDistance; farDistance: OrthographicFarDistance.
	]
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorSceneViewPanel >> updateCameraStateForRendering [
	self
		updateCameraProjection;
		updateGridTransform.
	camera transform: cameraTransform
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorSceneViewPanel >> updateGridTransform [
	| orientation scale renderPriority u v cameraTranslation du dv translation |
	orientation := isPerspective ifTrue: [ WMMatrix3F lookAtBottom ] ifFalse: [ gridOrientation ].
	renderPriority := isPerspective
		ifTrue: [ WDSGNode renderPriorityEditorOpaqueAfter ]
		ifFalse: [ WDSGNode renderPriorityEditorOpaqueBefore ].
		
	scale := self editor primaryGridSize / baseGridSize.
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

{ #category : #'rendering mode' }
WDGSLevelEditorSceneViewPanel >> wireframe [
	renderMode := #wire
]
