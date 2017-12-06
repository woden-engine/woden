rendering process stages
updateCameraFrustum
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