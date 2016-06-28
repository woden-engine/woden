private
releaseCanvas
	currentCanvas := nil.
	(vertices isNotEmpty and: [indices isNotEmpty]) ifTrue: [
		self dispatchRenderingCommands.
	].
	useOwnFramebuffer ifTrue: [
		synchronizationFence ifNil: [ synchronizationFence := engine device createFence ].
		commandQueue signalFence: synchronizationFence.
	]