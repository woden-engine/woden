Class {
	#name : #WDCStreamingBufferVector,
	#superclass : #Object,
	#instVars : [
		'elementType',
		'engine',
		'capacity',
		'elementSize',
		'reallocatedAction',
		'buffer'
	],
	#category : 'WodenEngine-Core-Pool'
}

{ #category : #bindings }
WDCStreamingBufferVector >> bind: slot storageOn: binding [
	binding bind: slot storageBuffer: self validBuffer offset: 0 size: self bufferSize value: self
]

{ #category : #bindings }
WDCStreamingBufferVector >> bind: slot uniformOn: binding [
	binding bind: slot uniformBuffer: self validBuffer offset: 0 size: self bufferSize value: self
]

{ #category : #accessing }
WDCStreamingBufferVector >> bufferSize [
	^ capacity * elementSize
]

{ #category : #accessing }
WDCStreamingBufferVector >> capacity [
	^ capacity
]

{ #category : #accessing }
WDCStreamingBufferVector >> capacity: anObject [
	capacity := anObject
]

{ #category : #accessing }
WDCStreamingBufferVector >> elementSize [
	^ elementSize
]

{ #category : #accessing }
WDCStreamingBufferVector >> elementType [
	^ elementType
]

{ #category : #accessing }
WDCStreamingBufferVector >> elementType: anObject [
	elementType := anObject.
	elementSize := elementType structureSize alignedTo: self minimalAlignment.
]

{ #category : #accessing }
WDCStreamingBufferVector >> engine [
	^ engine
]

{ #category : #accessing }
WDCStreamingBufferVector >> engine: anObject [
	engine := anObject
]

{ #category : #'as yet unclassified' }
WDCStreamingBufferVector >> ensureCapacityForAtLeast: count [
	^ self ensureCapacityForAtLeast: count keepOldData: false
]

{ #category : #'as yet unclassified' }
WDCStreamingBufferVector >> ensureCapacityForAtLeast: count keepOldData: keepOldData [
	| newCapacity oldCapacity oldBuffer |
	count <= capacity ifTrue: [ ^ self ].
	newCapacity := count asLargerPowerOfTwo.
	oldCapacity := capacity.
	
	"Just set the buffer to nil"
	capacity := newCapacity.
	oldBuffer := buffer.
	buffer := nil.
	
	(keepOldData and: [ oldBuffer isNotNil ]) ifTrue: [ 
		LibC memCopy: oldBuffer validPointer to: self validPointer size: oldCapacity * elementSize
	].
	
	reallocatedAction ifNotNil: [ reallocatedAction value: self ].
]

{ #category : #initialization }
WDCStreamingBufferVector >> initialize [
	super initialize.
	capacity := 128.
]

{ #category : #accessing }
WDCStreamingBufferVector >> minimalAlignment [
	^ 1
]

{ #category : #accessing }
WDCStreamingBufferVector >> reallocatedAction [
	^ reallocatedAction
]

{ #category : #accessing }
WDCStreamingBufferVector >> reallocatedAction: anObject [
	reallocatedAction := anObject
]

{ #category : #'as yet unclassified' }
WDCStreamingBufferVector >> validBuffer [
	buffer ifNil: [ buffer := self createBuffer: capacity ].
	^ buffer
]

{ #category : #'as yet unclassified' }
WDCStreamingBufferVector >> validPointer [
	^ self validBuffer validPointer
]
