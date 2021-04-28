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
	#category : #'WodenEngine-Roassal-Interaction'
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

{ #category : #actions }
RWAbstractHighlightable >> doHighlightElement: anElement [
	self subclassResponsibility
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
		objects := aBlock rwValue: el model.
		objects collect: [ :o | el view elementFromModel: o ]
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
	| elements |
	elements := nil.
	element
		when: RWMouseEnter do: [ :e |
			elements := 	(highlightElements rwValue: element) copyWithout: nil.
			elements do: [ :eachElement | self doHighlightElement: eachElement ].
		];
		when: RWMouseLeave do: [ :e |
			elements ifNotNil: [ 
				elements do: [ :eachElement | self doUnhighlightElement: eachElement ].
			].
		];
		when: RWTouch3DCursorEnter do: [ :e |
			elements := 	(highlightElements rwValue: element) copyWithout: nil.
			elements do: [ :eachElement | self doHighlightElement: eachElement ].
		];
		when: RWTouch3DCursorLeave do: [ :e |
			elements ifNotNil: [ 
				elements do: [ :eachElement | self doUnhighlightElement: eachElement ].
			].
		]
]
