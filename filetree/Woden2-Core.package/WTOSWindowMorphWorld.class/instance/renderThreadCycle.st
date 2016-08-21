render thread
renderThreadCycle
	self doSafely: [ self runLocalStepMethods ].
	needsRendering == true ifTrue: [
		self doSafely: [ self render ].
	].

	(Delay forMilliseconds: 10) wait.
