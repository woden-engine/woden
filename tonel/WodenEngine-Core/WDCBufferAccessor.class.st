Class {
	#name : #WDCBufferAccessor,
	#superclass : #Object,
	#instVars : [
		'bufferView',
		'type',
		'count',
		'min',
		'max'
	],
	#category : #'WodenEngine-Core-GPU-Resources'
}

{ #category : #converting }
WDCBufferAccessor >> asFirstIndexIndex [
	^ bufferView offset // type size
]

{ #category : #converting }
WDCBufferAccessor >> asIndexBuffer [
	^ bufferView buffer
]

{ #category : #converting }
WDCBufferAccessor >> asNativeArrayReference [
	^ SLVMNativeArrayReference for: type slvmType offset: bufferView offset size: count data: bufferView buffer data
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
WDCBufferAccessor >> count [
	^ count
]

{ #category : #accessing }
WDCBufferAccessor >> count: anObject [
	count := anObject
]

{ #category : #'as yet unclassified' }
WDCBufferAccessor >> engineChangedTo: anEngine [
	bufferView engineChangedTo: anEngine
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
