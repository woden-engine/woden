rendering
renderOnWindow: aWindow
	| frameIndex |
	frameIndex := engine newFrame.
	self renderContentOnWindow: aWindow frameIndex: frameIndex.
	self renderOverlaysOnWindow: aWindow frameIndex: frameIndex.