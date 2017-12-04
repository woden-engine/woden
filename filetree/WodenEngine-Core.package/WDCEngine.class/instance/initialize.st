initialization
initialize
	super initialize.
	projectionInvertedY := false.
	assetSearchPaths ifNil: [ 
		assetSearchPaths := OrderedCollection new.
		assetSearchPaths add: FileSystem workingDirectory / 'core-assets'.
	].
	self initializeForNewSession.