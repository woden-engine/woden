resource building
createGraphicsBundleCommandListAllocator
	^ (WTCommandListAllocator for: self) bundle; checkSession; yourself