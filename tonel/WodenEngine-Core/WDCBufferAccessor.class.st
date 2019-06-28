Class {
	#name : #WDCBufferAccessor,
	#superclass : #Object,
	#instVars : [
		'bufferView',
		'type',
		'count',
		'byteOffset',
		'min',
		'max'
	],
	#category : #'WodenEngine-Core-GPU-Resources'
}

{ #category : #converting }
WDCBufferAccessor >> applyAsIndexBufferToCommandList: commandListBuilder [
	commandListBuilder useIndexBufferAt: bufferView buffer validHandle offset: 0 index_size: type size
]

{ #category : #converting }
WDCBufferAccessor >> asFirstIndexIndex [
	^ (bufferView offset + byteOffset) // type size
]

{ #category : #converting }
WDCBufferAccessor >> asIndexBuffer [
	bufferView buffer description stride ~= type size ifTrue: [ ^ self ].
	^ bufferView buffer
]

{ #category : #converting }
WDCBufferAccessor >> asNativeArrayReference [
	^ SLVMNativeArrayReference for: type slvmType offset: bufferView offset + byteOffset size: count data: bufferView buffer data
]

{ #category : #accessing }
WDCBufferAccessor >> bufferView [
	^ bufferView
]

{ #category : #accessing }
WDCBufferAccessor >> bufferView: anObject [
	bufferView := anObject
]

{ #category : #accessing }
WDCBufferAccessor >> byteOffset [
	^ byteOffset
]

{ #category : #accessing }
WDCBufferAccessor >> byteOffset: anObject [
	byteOffset := anObject
]

{ #category : #accessing }
WDCBufferAccessor >> count [
	^ count
]

{ #category : #accessing }
WDCBufferAccessor >> count: anObject [
	count := anObject
]

{ #category : #'as yet unclassified' }
WDCBufferAccessor >> engine: anEngine [
	bufferView engine: anEngine
]

{ #category : #accessing }
WDCBufferAccessor >> max [
	^ max
]

{ #category : #accessing }
WDCBufferAccessor >> max: anObject [
	max := anObject
]

{ #category : #accessing }
WDCBufferAccessor >> min [
	^ min
]

{ #category : #accessing }
WDCBufferAccessor >> min: anObject [
	min := anObject
]

{ #category : #accessing }
WDCBufferAccessor >> type [
	^ type
]

{ #category : #accessing }
WDCBufferAccessor >> type: anObject [
	type := anObject
]
