as yet unclassified
validCommandAllocator
	^ commandAllocator ifNil: [ commandAllocator := engine createGraphicsDirectCommandListAllocator ]