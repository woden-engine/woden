Class {
	#name : #WDASceneViewScreenDisplayMode,
	#superclass : #Object,
	#instVars : [
		'engine',
		'view'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #'as yet unclassified' }
WDASceneViewScreenDisplayMode >> compositionShaderSignature [
	^ WDCCompositionShaderSignature for: engine
]

{ #category : #'as yet unclassified' }
WDASceneViewScreenDisplayMode >> computeProjectionMatrixFor: camera [
	^ camera frustum matrix
]

{ #category : #accessing }
WDASceneViewScreenDisplayMode >> engine [
	^ engine
]

{ #category : #accessing }
WDASceneViewScreenDisplayMode >> engine: anObject [
	engine := anObject
]

{ #category : #testing }
WDASceneViewScreenDisplayMode >> isVR [
	^ false
]

{ #category : #'rendering process stages' }
WDASceneViewScreenDisplayMode >> prepareDisplayMode [
	self updateCameraFrustum.

]

{ #category : #'rendering process stages' }
WDASceneViewScreenDisplayMode >> prepareRendering [
	self
		prepareDisplayMode;
		prepareSceneRenderer
]

{ #category : #'rendering process stages' }
WDASceneViewScreenDisplayMode >> prepareSceneRenderer [
	| renderTarget resolveTarget |
	renderTarget := view window validRenderTarget.
	resolveTarget := view window validResolveRenderTarget.
	view sceneRenderer
		useLateLatching: self useLateLatching;
		currentTime: view model currentTime;
		beginPreparingRendering;
		prepareRenderingForCamera: view cameraSceneNode withViewports: {
			self viewportForCamera: view cameraSceneNode renderTarget: renderTarget resolveRenderTarget: resolveTarget
		};
		endPreparingRendering
]

{ #category : #'rendering process stages' }
WDASceneViewScreenDisplayMode >> renderSceneViewports [
	^ view sceneRenderer renderSceneViewports
]

{ #category : #'as yet unclassified' }
WDASceneViewScreenDisplayMode >> submitLowLatencyData [
	self useLateLatching ifTrue: [
		view sceneRenderer submitCurrentCameraStates
	]
]

{ #category : #'rendering process stages' }
WDASceneViewScreenDisplayMode >> updateCameraFrustum [
	| camera extent aspect |
	camera := view cameraSceneNode.
	extent := view window drawingSurfaceExtent.
	aspect := extent x asFloat / extent y asFloat.
	camera updateFrustumWithAspectRatio: aspect projectionInvertedY: engine projectionInvertedY
]

{ #category : #'rendering process stages' }
WDASceneViewScreenDisplayMode >> useLateLatching [
	^ false
]

{ #category : #accessing }
WDASceneViewScreenDisplayMode >> view [
	^ view
]

{ #category : #accessing }
WDASceneViewScreenDisplayMode >> view: anObject [
	view := anObject
]

{ #category : #'as yet unclassified' }
WDASceneViewScreenDisplayMode >> viewportForCamera: camera renderTarget: renderTarget resolveRenderTarget: resolveTarget [
	^ self viewportForCamera: camera renderTarget: renderTarget resolveRenderTarget: resolveTarget submode: view renderSubMode
]

{ #category : #'as yet unclassified' }
WDASceneViewScreenDisplayMode >> viewportForCamera: camera renderTarget: renderTarget resolveRenderTarget: resolveRenderTarget submode: submode [
	| cameraState projectionMatrix |
	cameraState := WTCameraState new.
	projectionMatrix := self computeProjectionMatrixFor: camera.
	cameraState
		projectionMatrix: projectionMatrix;
		inverseProjectionMatrix: projectionMatrix inverted;
		clipMapCameraPosition: camera globalTransform translation;
		exposure: camera exposure.
	^ WDSGViewport new
		camera: camera;
		cameraState: cameraState;
		renderTarget: renderTarget;
		resolveRenderTarget: resolveRenderTarget;
		sampleCount: view sampleCount;
		bounds: resolveRenderTarget bounds;
		submode: submode;
		overlayRenderer: view;
		editorViewType: (view ifNotNil: #editorViewType);
		filter: (view filterForCameraViewport: camera)
]
