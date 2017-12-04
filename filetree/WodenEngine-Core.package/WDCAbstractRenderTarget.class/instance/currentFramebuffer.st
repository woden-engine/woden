accessing
currentFramebuffer
	framebuffers size == 1 ifTrue: [ framebuffers first ].
	^ framebuffers at: (engine bufferingFrameIndexModule: framebuffers size) + 1