resource building
createGraphicsBundleCommandListAllocator
	^ (WDCCommandListAllocator for: self) bundle; checkSession; yourself