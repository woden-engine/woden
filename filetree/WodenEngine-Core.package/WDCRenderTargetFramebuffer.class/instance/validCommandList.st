accessing
validCommandList
	^ commandList ifNil: [ commandList := self validCommandAllocator createListNow ]