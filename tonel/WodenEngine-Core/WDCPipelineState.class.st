Class {
	#name : #WDCPipelineState,
	#superclass : #Object,
	#instVars : [
		'description',
		'handle',
		'engine'
	],
	#category : #'WodenEngine-Core-GPU-Resources'
}

{ #category : #building }
WDCPipelineState >> build [
	self reload.
	description addDependantPipelineStateToShaders: self
]

{ #category : #accessing }
WDCPipelineState >> description [
	^ description
]

{ #category : #accessing }
WDCPipelineState >> description: anObject [
	description := anObject
]

{ #category : #accessing }
WDCPipelineState >> engine [
	^ engine
]

{ #category : #accessing }
WDCPipelineState >> engine: anObject [
	engine := anObject
]

{ #category : #accessing }
WDCPipelineState >> handle [
	^ handle
]

{ #category : #accessing }
WDCPipelineState >> handle: anObject [
	handle := anObject
]

{ #category : #building }
WDCPipelineState >> reload [
	handle := description buildForDevice: engine device.
]

{ #category : #path }
WDCPipelineState >> sessionChanged [
	self reload
]

{ #category : #accessing }
WDCPipelineState >> validHandle [
	^ handle
]
