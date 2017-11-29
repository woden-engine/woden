initialization
initialize
	super initialize.
	heapSize := self class defaultHeapSize.
	heaps := OrderedCollection new.