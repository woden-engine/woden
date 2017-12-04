dependencies
release
	framebuffers ifNotNil: [
		engine ifNotNil: [ engine graphicsQueue finishExecution ].
		framebuffers do: #release
	].
	framebuffers := nil.