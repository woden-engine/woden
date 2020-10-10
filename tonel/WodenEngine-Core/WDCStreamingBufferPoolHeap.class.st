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
		'elementType',
		'freeIndexList',
		'allocatedElements'
	],
	#category : #'WodenEngine-Core-Pool'
}

{ #category : #accessing }
WDCStreamingBufferPoolHeap >> allocate [
	| element elementIndex |
	self assert: (size < capacity or: [freeIndexList isNotEmpty]).
	
	elementIndex := nil.
	freeIndexList ifEmpty: [
		elementIndex := size + 1.
		size := size + 1.
	] ifNotEmpty: [
		elementIndex := freeIndexList last.
		freeIndexList removeLast.
	].

	element := WDCStreamingBufferPoolElement new
		heap: self;
		index: elementIndex;
		offset: elementSize * elementIndex;
		autoRelease;
		yourself.
	allocatedElements add: element.
	^ element

]

{ #category : #accessing }
WDCStreamingBufferPoolHeap >> buffer [
	^ buffer ifNil: [ buffer := pool createBuffer: capacity ]
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

{ #category : #accessing }
WDCStreamingBufferPoolHeap >> indexReleased: index [
	self pool mutex critical: [ 
		freeIndexList add: index
	].

]

{ #category : #initialization }
WDCStreamingBufferPoolHeap >> initialize [
	super initialize.
	size := 0.
	freeIndexList := OrderedCollection new.
	allocatedElements := WeakSet new.
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

{ #category : #path }
WDCStreamingBufferPoolHeap >> sessionChanged [
	pointer := nil.
	allocatedElements do: [ :each | each sessionChanged ]
]

{ #category : #accessing }
WDCStreamingBufferPoolHeap >> size [
	^ size
]
