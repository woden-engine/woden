Class {
	#name : #WDCStreamingStorageBufferPool,
	#superclass : #WDCStreamingBufferPool,
	#instVars : [
		'minimalAlignment'
	],
	#category : #'WodenEngine-Core-Pool'
}

{ #category : #'as yet unclassified' }
WDCStreamingStorageBufferPool >> createBuffer: capacity [
	^ engine createStreamingStorageBuffer: capacity * elementSize
]

{ #category : #'as yet unclassified' }
WDCStreamingStorageBufferPool >> minimalAlignment [
	^ minimalAlignment ifNil: [ minimalAlignment := engine minimalAlignmentForStorageBufferElement ]
]
