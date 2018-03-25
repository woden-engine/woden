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
	#category : 'WodenEngine-Scene-Application'
}

{ #category : #'as yet unclassified' }
WDASceneViewScreenDisplayMode >> computeProjectionMatrixFor: camera [
	| aspect extent |
	extent := view window drawingSurfaceExtent.
	aspect := extent x asFloat / extent y asFloat.
	^ camera isPerspective ifTrue: [
		WMMatrix4F reverseDepthPerspectiveFovY: camera fieldOfView aspect: aspect near: camera nearDistance far: camera farDistance invertedY: engine projectionInvertedY.
	] ifFalse: [
		"TODO: Compute a proper orthographic projection"
		WMMatrix4F reverseDepthPerspectiveFovY: camera fieldOfView aspect: aspect near: camera nearDistance far: camera farDistance invertedY: engine projectionInvertedY.
	]
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
		currentTime: view model currentTime;
		renderScene: view model scene viewports: {
			self viewportForCamera: view cameraSceneNode renderTarget: renderTarget resolveRenderTarget: resolveTarget
		}
]

{ #category : #'rendering process stages' }
WDASceneViewScreenDisplayMode >> updateCameraFrustum [
	| camera frustum extent aspect |
	camera := view cameraSceneNode.
	frustum := camera frustum.
	extent := view window drawingSurfaceExtent.
	aspect := extent x asFloat / extent y asFloat.
	camera isPerspective ifTrue: [
		frustum reverseDepthPerspectiveFovY: camera fieldOfView aspect: aspect near: camera nearDistance far: camera farDistance invertedY: engine projectionInvertedY.
	] ifFalse: [
		"TODO: Compute a proper orthographic projection"
		frustum reverseDepthPerspectiveFovY: camera fieldOfView aspect: aspect near: camera nearDistance far: camera farDistance invertedY: engine projectionInvertedY.
	]
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
	^ self viewportForCamera: camera renderTarget: renderTarget resolveRenderTarget: resolveTarget submode: #full
]

{ #category : #'as yet unclassified' }
WDASceneViewScreenDisplayMode >> viewportForCamera: camera renderTarget: renderTarget resolveRenderTarget: resolveRenderTarget submode: submode [
	| cameraState |
	cameraState := WTCameraState new.
	cameraState
		projectionMatrix: (self computeProjectionMatrixFor: camera).
	
	^ WTSViewport new
		camera: camera;
		cameraState: cameraState;
		renderTarget: renderTarget;
		resolveRenderTarget: resolveRenderTarget;
		bounds: renderTarget bounds;
		submode: submode
]

{ #category : #accessing }
WDASceneViewScreenDisplayMode >> vrSensorReader [
	^ nil
]
