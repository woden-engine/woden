triple buffering
newFrame
	graphicsQueue signalFence: self frameFence.
	frameIndex := frameIndex + 1.
	bufferingFrameIndex := (frameIndex % self frameBufferingCount) + 1.
	self frameFence waitOnClient.
	^ bufferingFrameIndex