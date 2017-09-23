dependencies
release
	framebuffers do: #release.
	colorBuffers do: #release.
	depthStencilBuffers ifNotNil: [
		depthStencilBuffers do: #release.
	].
