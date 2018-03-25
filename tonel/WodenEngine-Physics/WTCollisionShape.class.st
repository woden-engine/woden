Class {
	#name : #WTCollisionShape,
	#superclass : #Object,
	#instVars : [
		'handle'
	],
	#category : 'WodenEngine-Physics-Interface'
}

{ #category : #'as yet unclassified' }
WTCollisionShape >> accept: aVisitor [
	self subclassResponsibility
]

{ #category : #accessing }
WTCollisionShape >> handle [
	
	^ handle
]

{ #category : #accessing }
WTCollisionShape >> handle: anObject [
	
	handle := anObject
]

{ #category : #'as yet unclassified' }
WTCollisionShape >> hasValidHandle [
	^ handle ~~ nil and: [ handle isValid ]
]
