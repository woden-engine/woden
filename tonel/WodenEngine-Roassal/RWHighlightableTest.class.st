Class {
	#name : #RWHighlightableTest,
	#superclass : #RTTest,
	#instVars : [
		'box'
	],
	#category : 'WodenEngine-Roassal-Tests'
}

{ #category : #tests }
RWHighlightableTest >> testBasic [
	box := (RWCube new color: Color green) element.
	self assert: (box trachelShape color) = Color green.

	box @ RWHighlightable.
	self assert: (box trachelShape color) = Color green.
	
	box announce: RWMouseEnter.
	self assert: box trachelShape color = RTHighlightable highlightedColor.
	
	box announce: RWMouseLeave.
	self assert: (box trachelShape color) = Color green.
	

]

{ #category : #tests }
RWHighlightableTest >> testColoring [

	| v es |
	v := RWView new.
	
	es := ((RWCube new size: 1)) elementsOn: (1 to: 16).

	RWCubeLayout on: es.
	v addAll: es.

	es first color: Color blue.
	self assert: es second renderable color asColor equals: Color white.
]

{ #category : #tests }
RWHighlightableTest >> testHighlightAllSibblings [

	| v e1 e2 e3 |
	v := RWView new.
	e1 := (RWCube new color: Color gray) elementOn: 1.
	e2 := (RWUVSphere new color: Color gray) elementOn: 1.
	e3 := (RWCube new color: Color gray) elementOn: 2.
	
	v add: e1; add: e2; add: e3.
	
	e1 @ RWHighlightable allSibblings.
	self assert: (e1 shape colorFor: e1) = Color gray.
	self assert: (e2 shape colorFor: e2) = Color gray.
	self assert: (e3 shape colorFor: e3) = Color gray.
	
	e1 announce: RWMouseEnter.
	self assert: (e1 shape colorFor: e1) ~= Color gray.
	self assert: (e2 shape colorFor: e2) ~= Color gray.
	self assert: (e3 shape colorFor: e3) = Color gray.
]

{ #category : #tests }
RWHighlightableTest >> testMultipleElements [
	| box1 box2 |
	box1 := (RWCube new color: Color green) element.
	box2 := (RWCube new color: Color red) element.
	
	box1 @ (RWHighlightable highlightElements: [ :e | Array with: box2 ]).
	box1 announce: RWMouseEnter.

	"The Roassal shape remains the same"
	self assert: (box1 shape colorFor: box1) = Color green.
	self assert: box1 trachelShape color = Color green.
	self assert: box2 trachelShape color = RWHighlightable highlightedColor.
	
	box1 announce: RWMouseLeave.
	self assert: box1 trachelShape color = Color green.
	self assert: box2 trachelShape color = Color red
]

{ #category : #tests }
RWHighlightableTest >> testMultipleElementsDoHighlight [
	| box1 box2 h |
	box1 := (RWCube new color: Color green) elementOn: 1.
	box2 := (RWCube new color: Color red) elementOn: 2.
	
	h := RWHighlightable new highlightElements: [ :e | Array with: box2 ].
	h doHighlight: box1.
	
	"The Roassal shape remains the same"
	self assert: (box1 shape colorFor: box1) = Color green.
	self assert: box1 trachelShape color = Color green.
	self assert: box2 trachelShape color = RWHighlightable highlightedColor.
	
	h doUnhighlight: box1.
	self assert: box1 trachelShape color = Color green.
	self assert: box2 trachelShape color = Color red
]

{ #category : #tests }
RWHighlightableTest >> testScenario01 [

	| v es originalColor |

	v := RWView new.
	originalColor := Color white.
	es := ((RWCube new size: 1; color: originalColor)) elementsOn: (1 to: 16).

	RWCubeLayout on: es.
	v addAll: es.

	RWHighlightable new doHighlightElement: es first.
	
	self deny: (es second hasAttribute: #originalColor).
	RWHighlightable new doHighlightElement: es second.
	
	self assert: (es second attributes at: #originalColor) blue equals: 1.0.
	RWHighlightable new doUnhighlightElement: es first.
	
	self assert: (es second attributes at: #originalColor) blue equals: 1.0.
	RWHighlightable new doUnhighlightElement: es second.
	
	self assert: es second attributes size equals: 0
]
