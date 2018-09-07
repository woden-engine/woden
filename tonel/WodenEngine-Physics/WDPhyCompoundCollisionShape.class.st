Class {
	#name : #WDPhyCompoundCollisionShape,
	#superclass : #WDPhyCollisionShape,
	#instVars : [
		'components'
	],
	#category : #'WodenEngine-Physics-Interface'
}

{ #category : #'as yet unclassified' }
WDPhyCompoundCollisionShape class >> withComponents: aCollectionOfComponents [
	aCollectionOfComponents ifEmpty: [ ^ nil ].
	^ self new
		components: aCollectionOfComponents;
		yourself
]

{ #category : #'as yet unclassified' }
WDPhyCompoundCollisionShape >> accept: aVisitor [
	^ aVisitor visitCompoundShape: self
]

{ #category : #accessing }
WDPhyCompoundCollisionShape >> addComponent: aComponent [
	self components add: aComponent
]

{ #category : #accessing }
WDPhyCompoundCollisionShape >> components [
	^ components ifNil: [ components := OrderedCollection new. ]
]

{ #category : #accessing }
WDPhyCompoundCollisionShape >> components: aCollectionOfComponents [
	components := aCollectionOfComponents
]

{ #category : #initialization }
WDPhyCompoundCollisionShape >> initialize [
	super initialize.
]
