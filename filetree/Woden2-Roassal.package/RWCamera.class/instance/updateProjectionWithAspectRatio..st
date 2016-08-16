camera projection
updateProjectionWithAspectRatio: aspectRatio
	| engine |
	engine := sceneNode scene engine.
	frustum reverseDepthPerspectiveFovY: 60.0 aspect: aspectRatio near: 0.01 far: 1000.0 invertedY: engine projectionInvertedY.
	sceneNode state 
		projectionMatrix: frustum matrix.