Class {
	#name : #WDCStreamingBufferPoolElement,
	#superclass : #Object,
	#instVars : [
		'heap',
		'index',
		'offset',
		'next'
	],
	#category : 'WodenEngine-Core-Pool'
}

{ #category : #accessing }
WDCStreamingBufferPoolElement >> atomicSetValue: anObject [
	| bytes |
	bytes := anObject asByteArray.
	LibC memCopy: bytes to: heap pointer + offset size: bytes size
]

{ #category : #bindings }
WDCStreamingBufferPoolElement >> bind: slot storageOn: binding [
	binding bind: slot storageBuffer: heap buffer offset: offset size: heap elementSize value: self
]

{ #category : #bindings }
WDCStreamingBufferPoolElement >> bind: slot uniformOn: binding [
	binding bind: slot uniformBuffer: heap buffer offset: offset size: heap elementSize value: self
]

{ #category : #accessing }
WDCStreamingBufferPoolElement >> heap [
	^ heap
]

{ #category : #accessing }
WDCStreamingBufferPoolElement >> heap: anObject [
	heap := anObject
]

{ #category : #accessing }
WDCStreamingBufferPoolElement >> index [
	^ index
]

{ #category : #accessing }
WDCStreamingBufferPoolElement >> index: anObject [
	index := anObject
]

{ #category : #accessing }
WDCStreamingBufferPoolElement >> next [
	^ next
]

{ #category : #accessing }
WDCStreamingBufferPoolElement >> next: anObject [
	next := anObject
]

{ #category : #accessing }
WDCStreamingBufferPoolElement >> offset [
	^ offset
]

{ #category : #accessing }
WDCStreamingBufferPoolElement >> offset: anObject [
	offset := anObject
]

{ #category : #accessing }
WDCStreamingBufferPoolElement >> value [
	self halt.
]

{ #category : #accessing }
WDCStreamingBufferPoolElement >> value: anObject [
	anObject storeBytesIn: heap pointer position: offset + 1.
]
