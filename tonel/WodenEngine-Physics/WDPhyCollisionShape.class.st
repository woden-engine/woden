Class {
	#name : #WDPhyCollisionShape,
	#superclass : #Object,
	#instVars : [
		'handle'
	],
	#category : #'WodenEngine-Physics-Interface'
}

{ #category : #'as yet unclassified' }
WDPhyCollisionShape >> accept: aVisitor [
	self subclassResponsibility
]

{ #category : #accessing }
WDPhyCollisionShape >> handle [
	
	^ handle
]

{ #category : #accessing }
WDPhyCollisionShape >> handle: anObject [
	
	handle := anObject
]

{ #category : #'as yet unclassified' }
WDPhyCollisionShape >> hasValidHandle [
	^ handle ~~ nil and: [ handle isValid ]
]
