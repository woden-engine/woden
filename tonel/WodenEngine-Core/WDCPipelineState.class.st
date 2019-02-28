Class {
	#name : #WDCPipelineState,
	#superclass : #Object,
	#instVars : [
		'description',
		'handle',
		'device'
	],
	#category : 'WodenEngine-Core-GPU-Resources'
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
WDCPipelineState >> device [
	^ device
]

{ #category : #accessing }
WDCPipelineState >> device: anObject [
	device := anObject
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
	handle := description buildForDevice: device.
]

{ #category : #accessing }
WDCPipelineState >> validHandle [
	^ handle
]
