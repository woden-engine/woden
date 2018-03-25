Class {
	#name : #WDCStreamingStorageBufferVector,
	#superclass : #WDCStreamingBufferVector,
	#category : 'WodenEngine-Core-Pool'
}

{ #category : #private }
WDCStreamingStorageBufferVector >> createBuffer: bufferCapacity [
	^ engine createStreamingStorageBuffer: bufferCapacity * elementSize
]

{ #category : #'as yet unclassified' }
WDCStreamingStorageBufferVector >> minimalAlignment [
	^ 4
]
