rendering process
renderingProcess: process do: aBlock
	[
		aBlock value: process
	] on: Error do: [ :error |
		self addRenderProcess: process withError: error
	]