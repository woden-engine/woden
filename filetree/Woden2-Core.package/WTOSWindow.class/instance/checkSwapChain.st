factory
checkSwapChain
	| currentExtent |
	currentExtent := window extent.
	(currentExtent x ~= screenWidth or: [ currentExtent y ~= screenHeight ]) ifTrue: [
		"Finish all of the enqueued work."
		engine graphicsQueue finishExecution.
		
		"Release the swap chain"
		swapChain release.
		self createSwapChain.
	].
