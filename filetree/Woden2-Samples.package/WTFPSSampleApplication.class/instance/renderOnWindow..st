rendering
renderOnWindow: aWindow
	| frameIndex |
	frameIndex := engine newFrame.
	self updateCameraProjectionFor: aWindow.
	sceneRenderer
		currentTime: currentTime + accumulatedUpdateTime;
		renderFrame: frameIndex camera: camera on: aWindow.
	
	