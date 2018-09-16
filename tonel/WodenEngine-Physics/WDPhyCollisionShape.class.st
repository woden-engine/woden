Class {
	#name : #WDPhyCollisionShape,
	#superclass : #WDPhyObject,
	#category : #'WodenEngine-Physics-Interface'
}

{ #category : #'as yet unclassified' }
WDPhyCollisionShape >> accept: aVisitor [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDPhyCollisionShape >> hasValidHandle [
	^ handle ~~ nil and: [ handle isValid ]
]
