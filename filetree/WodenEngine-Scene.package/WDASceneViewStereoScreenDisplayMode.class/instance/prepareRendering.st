rendering process stages
prepareRendering
	| resolveTarget |
	self
		checkRenderTargets;
		updateCompositionState;
		uploadCompositionState;
		computeProjectionMatrices;
		updateCameraFrustum.
		
	resolveTarget := view window validResolveRenderTarget.
	^ view sceneRenderer
		currentTime: view model currentTime;
		renderScene: view model scene viewports: {
			self leftViewportForCamera: view cameraSceneNode.
			self rightViewportForCamera: view cameraSceneNode.
		}
		composeWith: [ :stateTracker |
			self composeEyesIn: stateTracker
		]
		mainResolveRenderTarget: resolveTarget
		