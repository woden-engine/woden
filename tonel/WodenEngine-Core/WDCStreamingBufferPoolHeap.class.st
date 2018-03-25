Class {
	#name : #WDCStreamingBufferPoolHeap,
	#superclass : #Object,
	#instVars : [
		'pool',
		'capacity',
		'size',
		'buffer',
		'pointer',
		'freeList',
		'elementSize',
		'elementType'
	],
	#category : 'WodenEngine-Core-Pool'
}

{ #category : #accessing }
WDCStreamingBufferPoolHeap >> allocate [
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

]

{ #category : #accessing }
WDCStreamingBufferPoolHeap >> buffer [
	buffer ifNil: [ buffer := pool createBuffer: capacity ].
	^ buffer
]

{ #category : #accessing }
WDCStreamingBufferPoolHeap >> capacity [
	^ capacity
]

{ #category : #accessing }
WDCStreamingBufferPoolHeap >> capacity: anObject [
	capacity := anObject
]

{ #category : #accessing }
WDCStreamingBufferPoolHeap >> elementSize [
	^ elementSize
]

{ #category : #accessing }
WDCStreamingBufferPoolHeap >> elementSize: anObject [
	elementSize := anObject
]

{ #category : #accessing }
WDCStreamingBufferPoolHeap >> elementType [
	^ elementType
]

{ #category : #accessing }
WDCStreamingBufferPoolHeap >> elementType: anObject [
	elementType := anObject
]

{ #category : #'as yet unclassified' }
WDCStreamingBufferPoolHeap >> flushBuffers [
	buffer ifNotNil: [ buffer validHandle flushWholeBuffer ]
]

{ #category : #accessing }
WDCStreamingBufferPoolHeap >> hasAvailableElement [
	^ size < capacity
]

{ #category : #initialization }
WDCStreamingBufferPoolHeap >> initialize [
	super initialize.
	size := 0.
]

{ #category : #accessing }
WDCStreamingBufferPoolHeap >> pointer [
	^ pointer ifNil: [ pointer := self buffer validPointer getHandle ]
]

{ #category : #accessing }
WDCStreamingBufferPoolHeap >> pool [
	^ pool
]

{ #category : #accessing }
WDCStreamingBufferPoolHeap >> pool: anObject [
	pool := anObject
]

{ #category : #accessing }
WDCStreamingBufferPoolHeap >> size [
	^ size
]
