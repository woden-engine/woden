Class {
	#name : #WDCStreamingUniformBufferPool,
	#superclass : #WDCStreamingBufferPool,
	#instVars : [
		'minimalAlignment'
	],
	#category : #'WodenEngine-Core-Pool'
}

{ #category : #'as yet unclassified' }
WDCStreamingUniformBufferPool >> createBuffer: capacity [
	^ engine createStreamingUniformBuffer: capacity * elementSize
]

{ #category : #accessing }
WDCStreamingUniformBufferPool >> minimalAlignment [
	^ minimalAlignment ifNil: [ minimalAlignment := engine minimalAlignmentForUniformBufferElement ]
]
