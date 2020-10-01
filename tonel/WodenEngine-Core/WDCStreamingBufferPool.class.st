Class {
	#name : #WDCStreamingBufferPool,
	#superclass : #Object,
	#instVars : [
		'elementType',
		'engine',
		'elementSize',
		'heapSize',
		'heaps'
	],
	#category : #'WodenEngine-Core-Pool'
}

{ #category : #settings }
WDCStreamingBufferPool class >> defaultHeapSize [
	^ 1024
]

{ #category : #construction }
WDCStreamingBufferPool class >> engine: engine elementType: elementType [
	^ self new engine: engine; elementType: elementType
]

{ #category : #accessing }
WDCStreamingBufferPool >> allocate [
	heaps do: [ :heap | heap hasAvailableElement ifTrue: [ ^ heap allocate ] ].
	self createHeap.
	^ heaps last allocate
]

{ #category : #'instance creation' }
WDCStreamingBufferPool >> allocate: numberOfElements [
	^ (1 to: numberOfElements) collect: [:i | self allocate]
]

{ #category : #private }
WDCStreamingBufferPool >> createBuffer: capacity [
	self subclassResponsibility
]

{ #category : #private }
WDCStreamingBufferPool >> createHeap [
	| heap |
	heap := WDCStreamingBufferPoolHeap new
		pool: self;
		capacity: heapSize;
		elementSize: elementSize;
		elementType: elementType;
		yourself.
	heaps add: heap.
]

{ #category : #accessing }
WDCStreamingBufferPool >> elementSize [
	^ elementSize
]

{ #category : #accessing }
WDCStreamingBufferPool >> elementType [
	^ elementType
]

{ #category : #accessing }
WDCStreamingBufferPool >> elementType: anObject [
	elementType := anObject.
	elementSize := elementType instanceSize alignedTo: self minimalAlignment.
	heapSize := elementType wodenPoolBufferHeapSize.
]

{ #category : #accessing }
WDCStreamingBufferPool >> engine [
	^ engine
]

{ #category : #accessing }
WDCStreamingBufferPool >> engine: anObject [
	engine := anObject
]

{ #category : #'as yet unclassified' }
WDCStreamingBufferPool >> flushBuffers [
	heaps do: #flushBuffers
]

{ #category : #private }
WDCStreamingBufferPool >> heapBufferSize [
	^ heapSize * elementSize
]

{ #category : #accessing }
WDCStreamingBufferPool >> heapSize [
	^ heapSize
]

{ #category : #accessing }
WDCStreamingBufferPool >> heapSize: anObject [
	heapSize := anObject
]

{ #category : #initialization }
WDCStreamingBufferPool >> initialize [
	super initialize.
	heaps := OrderedCollection new.
]

{ #category : #accessing }
WDCStreamingBufferPool >> minimalAlignment [
	^ 1
]
