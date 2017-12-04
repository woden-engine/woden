accessing
allocate
	| element |
	self assert: size < capacity.
	self flag: 'TODO: use a free list.'.
	element := WDCStreamingBufferPoolElement new
		heap: self;
		index: size + 1;
		offset: elementSize * size;
		yourself.
	size := size + 1.
	^ element
