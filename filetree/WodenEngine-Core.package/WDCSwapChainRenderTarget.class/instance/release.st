dependencies
release
	super release.
	swapChain ifNotNil: [ swapChain release. ].
	swapChain := nil.
	