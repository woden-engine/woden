rendering process stages
prepareRendering
	| renderTarget resolveTarget |
	renderTarget := view window validRenderTarget.
	resolveTarget := view window validResolveRenderTarget.
	self updateCameraFrustum.
	^ view sceneRenderer
		currentTime: view model currentTime;
		renderScene: view model scene viewports: {
			self viewportForCamera: view cameraSceneNode renderTarget: renderTarget resolveRenderTarget: resolveTarget
		}