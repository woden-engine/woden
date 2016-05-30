resource building
findCommandQueue
	queueType == #graphics ifTrue: [ ^ engine graphicsQueue ].
	self error: 'Unsupported command queue ', queueType printString