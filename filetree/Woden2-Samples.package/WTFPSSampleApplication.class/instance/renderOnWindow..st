rendering
renderOnWindow: aWindow
	| frameIndex |
	frameIndex := engine newFrame.
	self updateCameraProjectionFor: aWindow.
	sceneRenderer renderFrame: frameIndex camera: camera on: aWindow.
	
	