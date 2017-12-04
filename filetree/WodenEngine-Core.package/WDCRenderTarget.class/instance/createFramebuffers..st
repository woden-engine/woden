accessing
createFramebuffers: aCount
	| oldFramebuffers |
	oldFramebuffers := framebuffers.
	framebuffers := (1 to: aCount) collect: [:i |
		self createFramebuffer
			initializeExtraStateFrom: (oldFramebuffers ifNotNil: [oldFramebuffers at: i]);
		yourself
	].
