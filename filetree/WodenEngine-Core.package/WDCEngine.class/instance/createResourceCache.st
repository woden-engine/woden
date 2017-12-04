initialization
createResourceCache
	resourceCache ifNil: [
		resourceCache := WDCResourceCache new.
		resourceCache initializeForEngine: self.
 	].

	resourceCache sessionChanged