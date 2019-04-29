Class {
	#name : #RWHighlightable,
	#superclass : #RWAbstractHighlightable,
	#instVars : [
		'color'
	],
	#category : #'WodenEngine-Roassal-Interaction'
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
	anElement attributes at: #originalColor put: anElement color.
	anElement color: (self highlightColorFor: anElement).
	anElement changed.

]

{ #category : #actions }
RWHighlightable >> doUnhighlightElement: anElement [
	(anElement attributes includesKey: #originalColor)
		ifFalse: [ ^ self ].

	anElement color: (anElement attributes at: #originalColor).
	anElement attributes removeKey: #originalColor.
	anElement changed.
	
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
	anElement attributes at: #originalColor put: (anElement color)

]
