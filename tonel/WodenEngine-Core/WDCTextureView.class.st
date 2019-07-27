Class {
	#name : #WDCTextureView,
	#superclass : #WDCResourceWithSessionHandle,
	#instVars : [
		'texture',
		'description'
	],
	#category : #'WodenEngine-Core-GPU-Resources'
}

{ #category : #converting }
WDCTextureView >> asValidTextureViewHandle [
	^ self validHandle
]

{ #category : #'resource building' }
WDCTextureView >> buildHandle [
	self assert: texture isNotNil.
	self assert: description isNotNil.
	handle := texture validHandle createView: description.
]

{ #category : #accessing }
WDCTextureView >> description [
	^ description
]

{ #category : #accessing }
WDCTextureView >> description: anObject [
	description := anObject
]

{ #category : #accessing }
WDCTextureView >> extent [
	^ texture extent
]

{ #category : #accessing }
WDCTextureView >> texture [
	^ texture
]

{ #category : #accessing }
WDCTextureView >> texture: anObject [
	texture := anObject
]
