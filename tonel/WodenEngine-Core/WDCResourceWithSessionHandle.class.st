Class {
	#name : #WDCResourceWithSessionHandle,
	#superclass : #Object,
	#instVars : [
		'engine',
		'session',
		'handle'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : 'WodenEngine-Core-GPU-Resources'
}

{ #category : #'as yet unclassified' }
WDCResourceWithSessionHandle class >> for: anEngine [
	^ self new engine: anEngine
]

{ #category : #'as yet unclassified' }
WDCResourceWithSessionHandle class >> for: anEngine handle: aHandle [
	^ self new engine: anEngine; handle: aHandle; yourself
]

{ #category : #'resource building' }
WDCResourceWithSessionHandle >> buildHandle [
	self subclassResponsibility
]

{ #category : #'session management' }
WDCResourceWithSessionHandle >> checkSession [
	session ~~ Smalltalk session ifTrue: [
		engine checkSession.
		self buildHandle.
		session := Smalltalk session.
	]
]

{ #category : #accessing }
WDCResourceWithSessionHandle >> engine [
	^ engine
]

{ #category : #accessing }
WDCResourceWithSessionHandle >> engine: anObject [
	engine := anObject
]

{ #category : #accessing }
WDCResourceWithSessionHandle >> handle [
	^ handle
]

{ #category : #accessing }
WDCResourceWithSessionHandle >> handle: aHandle [
	handle := aHandle.
	session := Smalltalk session.
]

{ #category : #testing }
WDCResourceWithSessionHandle >> hasValidHandle [
	^ handle isNotNil and: [ session == Smalltalk session ]
]

{ #category : #accessing }
WDCResourceWithSessionHandle >> session [
	^ session
]

{ #category : #accessing }
WDCResourceWithSessionHandle >> validHandle [
	self checkSession.
	^ handle
]
