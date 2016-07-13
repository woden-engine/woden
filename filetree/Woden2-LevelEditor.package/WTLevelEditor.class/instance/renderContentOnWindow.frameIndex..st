rendering
renderContentOnWindow: aWindow frameIndex: frameIndex
	self updateCameraProjectionFor: aWindow.
	sceneRenderer
		currentTime: currentTime + accumulatedUpdateTime;
		renderFrame: frameIndex camera: camera on: aWindow.