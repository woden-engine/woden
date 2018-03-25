Class {
	#name : #WDCVertexLayout,
	#superclass : #Object,
	#instVars : [
		'buffers',
		'handle'
	],
	#category : 'WodenEngine-Core-GPU-Resources'
}

{ #category : #accessing }
WDCVertexLayout >> buffers [
	^ buffers
]

{ #category : #accessing }
WDCVertexLayout >> buffers: anObject [
	buffers := anObject
]

{ #category : #accessing }
WDCVertexLayout >> handle [
	^ handle
]

{ #category : #accessing }
WDCVertexLayout >> handle: anObject [
	handle := anObject
]

{ #category : #accessing }
WDCVertexLayout >> validHandle [
	(handle isNil or: [ handle isNull ]) ifTrue: [ self error: 'Handle is not valid' ].
	^ handle
]
