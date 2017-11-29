private
createHeap
	| heap |
	heap := WTStreamingBufferPoolHeap new
		pool: self;
		capacity: heapSize;
		elementSize: elementSize;
		elementType: elementType;
		yourself.
	heaps add: heap.