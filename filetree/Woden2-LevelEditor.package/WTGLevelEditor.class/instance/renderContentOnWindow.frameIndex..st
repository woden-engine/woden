rendering
renderContentOnWindow: aWindow frameIndex: frameIndex
	levelViews do: #updateCameraStateForRendering.
	sceneRenderer
		currentTime: currentTime + accumulatedUpdateTime;
		renderFrame: frameIndex viewports: (levelViews collect: #viewport) on: aWindow currentFramebuffer