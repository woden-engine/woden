Class {
	#name : #WDCStreamingUniformBufferPool,
	#superclass : #WDCStreamingBufferPool,
	#category : 'WodenEngine-Core-Pool'
}

{ #category : #'as yet unclassified' }
WDCStreamingUniformBufferPool >> createBuffer: capacity [
	^ engine createStreamingUniformBuffer: capacity * elementSize
]

{ #category : #'as yet unclassified' }
WDCStreamingUniformBufferPool >> minimalAlignment [
	^ 256
]
