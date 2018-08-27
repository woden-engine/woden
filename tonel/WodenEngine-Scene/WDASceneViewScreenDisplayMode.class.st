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
WDASceneViewScreenDisplayMode >> prepareRendering [
	| renderTarget resolveTarget |
	renderTarget := view window validRenderTarget.
	resolveTarget := view window validResolveRenderTarget.
	self updateCameraFrustum.
	^ view sceneRenderer
		useLateLatching: self useLateLatching;
		currentTime: view model currentTime;
		renderScene: view model scene viewports: {
			self viewportForCamera: view cameraSceneNode renderTarget: renderTarget resolveRenderTarget: resolveTarget
		}
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
	| cameraState |
	cameraState := WTCameraState new.
	cameraState
		projectionMatrix: (self computeProjectionMatrixFor: camera).
	
	^ WDSGViewport new
		camera: camera;
		cameraState: cameraState;
		renderTarget: renderTarget;
		resolveRenderTarget: resolveRenderTarget;
		bounds: renderTarget bounds;
		submode: submode;
		overlayRenderer: view;
		filter: (view filterForCameraViewport: camera)
]

{ #category : #accessing }
WDASceneViewScreenDisplayMode >> vrSensorReader [
	^ nil
]
