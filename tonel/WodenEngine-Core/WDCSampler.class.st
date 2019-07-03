Class {
	#name : #WDCSampler,
	#superclass : #WDCResourceWithSessionHandle,
	#instVars : [
		'description'
	],
	#category : #'WodenEngine-Core-GPU-Resources'
}

{ #category : #'resource building' }
WDCSampler >> buildHandle [
	self assert: description isNotNil.
	handle := engine device createSampler: description.
]

{ #category : #accessing }
WDCSampler >> description [
	^ description
]

{ #category : #accessing }
WDCSampler >> description: anObject [
	description := anObject
]
