render thread
createRenderThread
	^ [
		[
			self renderThreadCycle
		] repeat.
	] fork