private
releaseCanvas
	currentCanvas := nil.
	(vertices isNotEmpty and: [indices isNotEmpty]) ifTrue: [
		self dispatchRenderingCommands.
	].
	useOwnFramebuffer ifTrue: [
		self signalFence
	]