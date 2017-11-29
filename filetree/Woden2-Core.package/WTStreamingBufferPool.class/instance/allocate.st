accessing
allocate
	heaps do: [ :heap | heap hasAvailableElement ifTrue: [ ^ heap allocate ] ].
	self createHeap.
	^ heaps last allocate