resource building
createGraphicsDirectCommandListAllocator
	^ (WTCommandListAllocator for: self) direct; checkSession; yourself