Class {
	#name : #WDCStreamingStorageBufferPool,
	#superclass : #WDCStreamingBufferPool,
	#category : 'WodenEngine-Core-Pool'
}

{ #category : #'as yet unclassified' }
WDCStreamingStorageBufferPool >> createBuffer: capacity [
	^ engine createStreamingStorageBuffer: capacity * elementSize
]

{ #category : #'as yet unclassified' }
WDCStreamingStorageBufferPool >> minimalAlignment [
	^ 4
]
