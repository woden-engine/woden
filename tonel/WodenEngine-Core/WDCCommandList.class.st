Class {
	#name : #WDCCommandList,
	#superclass : #WDCResourceWithSessionHandle,
	#instVars : [
		'allocator'
	],
	#category : 'WodenEngine-Core-GPU-Resources'
}

{ #category : #accessing }
WDCCommandList >> allocator [
	^ allocator
]

{ #category : #accessing }
WDCCommandList >> allocator: anObject [
	allocator := anObject
]

{ #category : #'resource building' }
WDCCommandList >> buildHandle [
	handle := engine device createCommandList: allocator listType allocator: allocator validHandle initial_pipeline_state: nil.
	self assert: handle isNull not.
	handle close.
]

{ #category : #'as yet unclassified' }
WDCCommandList >> withPipelineState: pipelineState isCached: isCached rebuild: aBlock [
	isCached ifFalse: [ self withPipelineState: pipelineState rebuild: aBlock ]
]

{ #category : #'as yet unclassified' }
WDCCommandList >> withPipelineState: pipelineState rebuild: aBlock [
	self validHandle
		reset: allocator validHandle initial_pipeline_state: (pipelineState ifNotNil: [ pipelineState validHandle ]).
	aBlock value: handle.
	handle close.
]

{ #category : #'as yet unclassified' }
WDCCommandList >> withPipelineState: pipelineState renderpass: renderpass rebuildBundle: aBlock [
	| inheritance |
	inheritance := AGPUInheritanceInfo new.
	inheritance renderpass: renderpass validHandle validHandle.
	
	self validHandle
		resetBundle: allocator validHandle initial_pipeline_state: (pipelineState ifNotNil: [ pipelineState validHandle ]) inheritance_info: inheritance.
	aBlock value: handle.
	handle close.
]
