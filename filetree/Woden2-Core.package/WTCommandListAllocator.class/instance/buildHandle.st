resource building
buildHandle
	queue := self findCommandQueue.
	handle := engine device createCommandAllocator: AGPU_COMMAND_LIST_TYPE_DIRECT queue: queue.
	self assert: handle isNull not.