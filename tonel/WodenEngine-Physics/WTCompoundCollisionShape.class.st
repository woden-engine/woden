Class {
	#name : #WTCompoundCollisionShape,
	#superclass : #WTCollisionShape,
	#instVars : [
		'components'
	],
	#category : 'WodenEngine-Physics-Interface'
}

{ #category : #'as yet unclassified' }
WTCompoundCollisionShape >> accept: aVisitor [
	^ aVisitor visitCompoundShape: self
]

{ #category : #accessing }
WTCompoundCollisionShape >> components [
	^ components
]

{ #category : #initialization }
WTCompoundCollisionShape >> initialize [
	super initialize.
	components := OrderedCollection new.
]
