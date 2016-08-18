render thread
renderThreadCycle
	needsRendering == true ifTrue: [
		self doSafely: [ self render ].
	].

	(Delay forMilliseconds: 10) wait.
