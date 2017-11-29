initialization
initialize
	super initialize.
	frameIndex := -1.
	bufferingFrameIndex := 1.
	projectionInvertedY := false.
	assetSearchPaths ifNil: [ 
		assetSearchPaths := OrderedCollection new.
		assetSearchPaths add: FileSystem workingDirectory / 'core-assets'.
	].

	self initializeForNewSession.
