initialization
createResourceCache
	resourceCache ifNil: [
		resourceCache := WTResourceCache new.
		resourceCache initializeForEngine: self.
 	].

	resourceCache sessionChanged