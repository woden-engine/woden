Class {
	#name : #WDPhyCollisionShape,
	#superclass : #WDPhyObject,
	#category : #'WodenEngine-Physics-Interface'
}

{ #category : #'as yet unclassified' }
WDPhyCollisionShape >> accept: aVisitor [
	self subclassResponsibility
]

{ #category : #converting }
WDPhyCollisionShape >> asCollisionShape [
	^ self
]

{ #category : #converting }
WDPhyCollisionShape >> asCompoundCollisionShapeComponent [
	^ WDPhyCompoundCollisionShapeComponent new
		transform: ReversibleAffineTransform3dF32 identity;
		shape: self;
		yourself
]

{ #category : #'as yet unclassified' }
WDPhyCollisionShape >> hasValidHandle [
	^ handle ~~ nil and: [ handle isValid ]
]

{ #category : #converting }
WDPhyCollisionShape >> isCompoundCollisionShapeComponent [
	^ false
]
