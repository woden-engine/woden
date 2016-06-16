initialization
initializeForEngine: anEngine
	engine := anEngine.
	fonts := Dictionary new.
	self loadFonts.