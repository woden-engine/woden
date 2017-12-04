rendering process stages
prepareRendering
	| renderTarget resolveTarget |
	renderTarget :=  window validRenderTarget.
	resolveTarget := window validResolveRenderTarget.
	self updateCameraProjection.
	commandList := self sceneRenderer
		currentTime: model currentTime;
		renderScene: model scene viewports: (self camera viewportsForRenderTarget: renderTarget resolveRenderTarget: resolveTarget submode: #full)