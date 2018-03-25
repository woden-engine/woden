Class {
	#name : #RWAbstractHighlightable,
	#superclass : #RWElementInteraction,
	#instVars : [
		'highlightElements'
	],
	#classInstVars : [
		'lastHighlightedElements',
		'lastColor'
	],
	#category : 'Woden2-Roassal-Core'
}

{ #category : #public }
RWAbstractHighlightable class >> allSibblings [

	^ self highlightElements: [ :el | el view elements select: [ :e | e model notNil and: [ e model == el model ]] ]
]

{ #category : #public }
RWAbstractHighlightable class >> highlight: aBlock [
	"aBlock return an element or a list of elements to highlight"
	^ self new highlight: aBlock
]

{ #category : #public }
RWAbstractHighlightable class >> highlightElements: aBlock [
	"aBlock return an element or a list of elements to highlight"
	^ self new highlightElements: aBlock
]

{ #category : #'reset shape' }
RWAbstractHighlightable class >> lastHighlightedElements [
	^ lastHighlightedElements
]

{ #category : #'reset shape' }
RWAbstractHighlightable class >> lastHighlightedElements: elements [
	lastHighlightedElements := elements
]

{ #category : #private }
RWAbstractHighlightable >> attributeIdentificator [
	^ self className asSymbol
]

{ #category : #actions }
RWAbstractHighlightable >> doHighlight: element [
	| elements |
	self unhighlightRecordedElements.
	elements := highlightElements rtValue: element.
	elements := elements copyWithout: nil.
	elements do: [ :eachElement | self doHighlightElement: eachElement ].
	element attributes at: self attributeIdentificator put: elements.
	self class lastHighlightedElements: elements
]

{ #category : #actions }
RWAbstractHighlightable >> doHighlightElement: anElement [
	self subclassResponsibility
]

{ #category : #actions }
RWAbstractHighlightable >> doUnhighlight: element [
	(element hasAttribute: self attributeIdentificator)
		ifFalse: [ ^ self ].
	(element attributeAt: self attributeIdentificator) 
		do: [ :el | self doUnhighlightElement: el ].
	element removeAttributeAt: self attributeIdentificator.
]

{ #category : #actions }
RWAbstractHighlightable >> doUnhighlightElement: anElement [
	self subclassResponsibility
]

{ #category : #public }
RWAbstractHighlightable >> highlight: aBlock [
	"aBlock return an object or a list of objects to highlight"
	highlightElements := [ :el | 
		| objects |
		objects := aBlock rtValue: el model.
		(objects collect: [ :o | el view elementFromModel: o ]) copyWithout: nil
		]
]

{ #category : #public }
RWAbstractHighlightable >> highlightElements: aBlock [
	"aBlock return an element or a list of elements to highlight"
	highlightElements := aBlock
]

{ #category : #initialize }
RWAbstractHighlightable >> initialize [
	super initialize.
	self highlightElements: [ :el | Array with: el ]
]

{ #category : #hooks }
RWAbstractHighlightable >> initializeElement: element [
	element
		when: RWMouseEnter
		do: [ :e | 
			self doHighlight: element.
			e signalUpdate ].
	element
		when: RWMouseLeave
		do: [ :e | 
			self doUnhighlight: element.
			e signalUpdate ]
]

{ #category : #actions }
RWAbstractHighlightable >> unhighlightRecordedElements [
	self class lastHighlightedElements ifNil: [ ^ self ].
	self class lastHighlightedElements do: [ :el | self doUnhighlightElement: el ].
	self class lastHighlightedElements: nil
]
