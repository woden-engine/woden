rendering process stages
prepareRendering
	| renderTarget resolveTarget |
	renderTarget :=  view window validRenderTarget.
	resolveTarget := view window validResolveRenderTarget.
	^ view sceneRenderer
		currentTime: view model currentTime;
		renderScene: view model scene viewports: {
			self viewportForCamera: view camera renderTarget: renderTarget resolveRenderTarget: resolveTarget
		}