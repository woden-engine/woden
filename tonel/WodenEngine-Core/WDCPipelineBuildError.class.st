"
I am an error that is thrown when building a pipeline state fails.
"
Class {
	#name : #WDCPipelineBuildError,
	#superclass : #Error,
	#instVars : [
		'pipelineDescription'
	],
	#category : 'WodenEngine-Core-Rendering'
}

{ #category : #accessing }
WDCPipelineBuildError >> pipelineDescription [
	^ pipelineDescription
]

{ #category : #accessing }
WDCPipelineBuildError >> pipelineDescription: anObject [
	pipelineDescription := anObject
]
