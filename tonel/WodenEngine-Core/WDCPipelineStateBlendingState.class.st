Class {
	#name : #WDCPipelineStateBlendingState,
	#superclass : #WDCBlendingMode,
	#instVars : [
		'targetMask'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : 'WodenEngine-Core-Rendering'
}

{ #category : #initialization }
WDCPipelineStateBlendingState class >> initialize [
]

{ #category : #comparing }
WDCPipelineStateBlendingState >> = other [
	^ super = other and: [ targetMask = other targetMask ]
]

{ #category : #accessing }
WDCPipelineStateBlendingState >> alphaOperation [
	^ alphaOperation
]

{ #category : #accessing }
WDCPipelineStateBlendingState >> alphaOperation: anObject [
	alphaOperation := anObject
]

{ #category : #'pipeline state building' }
WDCPipelineStateBlendingState >> applyOn: builder [
	builder setBlendState: targetMask enabled: enabled.
	enabled ifTrue: [
		builder setBlendFunction: targetMask
		sourceFactor: sourceFactor destFactor: destFactor colorOperation: operation
		sourceAlphaFactor: sourceAlphaFactor destAlphaFactor: destAlphaFactor alphaOperation: alphaOperation
	].
]

{ #category : #converting }
WDCPipelineStateBlendingState >> asPipelineStateBlendingState [
	^ self copy
]

{ #category : #accessing }
WDCPipelineStateBlendingState >> destAlphaFactor [
	^ destAlphaFactor
]

{ #category : #accessing }
WDCPipelineStateBlendingState >> destAlphaFactor: anObject [
	destAlphaFactor := anObject
]

{ #category : #accessing }
WDCPipelineStateBlendingState >> destFactor [
	^ destFactor
]

{ #category : #accessing }
WDCPipelineStateBlendingState >> destFactor: anObject [
	destFactor := anObject
]

{ #category : #accessing }
WDCPipelineStateBlendingState >> enabled [
	^ enabled
]

{ #category : #accessing }
WDCPipelineStateBlendingState >> enabled: anObject [
	enabled := anObject
]

{ #category : #comparing }
WDCPipelineStateBlendingState >> hash [
	^ super hash bitXor: ( targetMask hash )
]

{ #category : #accessing }
WDCPipelineStateBlendingState >> operation [
	^ operation
]

{ #category : #accessing }
WDCPipelineStateBlendingState >> operation: anObject [
	operation := anObject
]

{ #category : #accessing }
WDCPipelineStateBlendingState >> sourceAlphaFactor [
	^ sourceAlphaFactor
]

{ #category : #accessing }
WDCPipelineStateBlendingState >> sourceAlphaFactor: anObject [
	sourceAlphaFactor := anObject
]

{ #category : #accessing }
WDCPipelineStateBlendingState >> sourceFactor [
	^ sourceFactor
]

{ #category : #accessing }
WDCPipelineStateBlendingState >> sourceFactor: anObject [
	sourceFactor := anObject
]

{ #category : #accessing }
WDCPipelineStateBlendingState >> targetMask [
	^ targetMask
]

{ #category : #accessing }
WDCPipelineStateBlendingState >> targetMask: anObject [
	targetMask := anObject
]
