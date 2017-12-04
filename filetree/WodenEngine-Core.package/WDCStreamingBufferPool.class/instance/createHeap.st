private
createHeap
	| heap |
	heap := WDCStreamingBufferPoolHeap new
		pool: self;
		capacity: heapSize;
		elementSize: elementSize;
		elementType: elementType;
		yourself.
	heaps add: heap.