triple buffering
newFrame
	| fence |
	fence := frameFences at: bufferingFrameIndex.
	fence ifNil: [ 
		fence := device createFence.
		frameFences at: bufferingFrameIndex put: fence.
	].

	graphicsQueue signalFence: fence.

	frameIndex := frameIndex + 1.
	bufferingFrameIndex := (frameIndex % self frameBufferingCount) + 1.
	
	fence := frameFences at: bufferingFrameIndex.
	fence ifNotNil: [ fence waitOnClient ].
	^ bufferingFrameIndex