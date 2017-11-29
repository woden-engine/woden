rendering
render3DOnWindow: aWindow extraRenderTime: extraRenderTime
	| aspect frameIndex |
	frameIndex := engine bufferingFrameIndex. 
	aspect := aWindow screenWidth asFloat / aWindow screenHeight asFloat.
	camera updateProjectionWithAspectRatio: aspect.
	sceneRenderer ifNil: [ self createSceneRenderer ].
	sceneRenderer
		currentTime: currentTime + extraRenderTime;
		renderFrame: frameIndex camera: camera sceneNode on: aWindow.
