rendering process stages
prepareRendering
	| resolveTarget |
	self
		checkRenderTargets;
		updateCompositionState;
		uploadCompositionState;
		computeProjectionMatrices.
		
	resolveTarget := view window validResolveRenderTarget.
	^ view sceneRenderer
		currentTime: view model currentTime;
		renderScene: view model scene viewports: {
			self leftViewportForCamera: view camera.
			self rightViewportForCamera: view camera.
		}
		composeWith: [ :stateTracker |
			self composeEyesIn: stateTracker
		]
		mainResolveRenderTarget: resolveTarget
		