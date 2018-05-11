Class {
	#name : #RWHighlightable,
	#superclass : #RWAbstractHighlightable,
	#instVars : [
		'color'
	],
	#category : 'WodenEngine-Roassal-Core'
}

{ #category : #'reset shape' }
RWHighlightable class >> highlightedColor [
	^ Color blue
]

{ #category : #visitor }
RWHighlightable >> accept: aVisitor with: args [
	aVisitor visitHightlightableInteraction: self with: args.
]

{ #category : #actions }
RWHighlightable >> doHighlightElement: anElement [
	| v |
	self recordElement: anElement.	"not sure if we need to return something"
	v := anElement trachelShape color: (self highlightColorFor: anElement).
	anElement signalUpdate.
	^ v
]

{ #category : #actions }
RWHighlightable >> doUnhighlightElement: anElement [
	(anElement attributes includesKey: #originalColor)
		ifFalse: [ ^ self ].
	anElement trachelShape color: (anElement attributes at: #originalColor).
	anElement attributes removeKey: #originalColor.
	"anElement view ifNotNil: [ anElement view signalUpdate ]."
	anElement signalUpdate.
	
]

{ #category : #utility }
RWHighlightable >> highlightColorFor: anElement [
	"Return the highlight color"
	^ self highlightedColor rwValue: anElement model
]

{ #category : #configuration }
RWHighlightable >> highlightedColor [
	^ color
]

{ #category : #configuration }
RWHighlightable >> highlightedColor: aColorOrABlock [
	color := aColorOrABlock
]

{ #category : #initialize }
RWHighlightable >> initialize [
	super initialize.
	color := self class highlightedColor
]

{ #category : #actions }
RWHighlightable >> recordElement: anElement [
	anElement attributes at: #originalColor put: (anElement trachelShape color)

]
