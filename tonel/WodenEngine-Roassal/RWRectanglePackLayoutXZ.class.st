"
I pack rectangles in XZ pane.

#gap parameter sets a gap between elements
"
Class {
	#name : #RWRectanglePackLayoutXZ,
	#superclass : #RWLayout,
	#instVars : [
		'freeSpace',
		'bounds',
		'gap'
	],
	#category : 'WodenEngine-Roassal-Layout'
}

{ #category : #'space-calculation' }
RWRectanglePackLayoutXZ >> areasOverlaping: oneRect outsideOf: anotherRect [ 
	"Answer an Array of maximized Rectangles comprising (overlaped by each other) the parts of the receiver not 
	intersecting aRectangle."
	"Make sure the intersection is non-empty"
	| areas |
	(oneRect intersects: anotherRect) ifFalse: [ ^ Array with: oneRect ].
	areas := OrderedCollection new.
	anotherRect origin y > oneRect origin y 
		ifTrue: 
			[ areas addLast: (oneRect origin corner: oneRect corner x @ anotherRect origin y) ].
	anotherRect corner y < oneRect corner y 
		ifTrue: 
			[ areas addLast: (oneRect origin x @ anotherRect corner y corner: oneRect corner) ].
	anotherRect origin x > oneRect origin x 
		ifTrue: 
			[ areas addLast: (oneRect origin corner: anotherRect origin x @ oneRect corner y) ].
	anotherRect corner x < oneRect corner x 
		ifTrue: 
			[ areas addLast: (anotherRect corner x @ oneRect origin y corner: oneRect corner) ].
	^ areas
]

{ #category : #'space-calculation' }
RWRectanglePackLayoutXZ >> bestSpaceFor: anElement [
	| elementsPadedExtent suitableSpaces |
	
	elementsPadedExtent := (anElement width @ anElement depth) + (gap * 2).
	
	suitableSpaces := freeSpace select: [ :space |
		elementsPadedExtent x <= space width and:
			[ elementsPadedExtent y <= space height ] ].
	
	^ (suitableSpaces
		fold: [ :best :current |
			| bestExt currentExt | 
			((currentExt := self extentByInserting: elementsPadedExtent into: current) <
			(bestExt := self extentByInserting: elementsPadedExtent  into: best) or: [ 
				currentExt = bestExt and: [
					(current width + current height) <
					(   best width +    best height) ] ])
						ifTrue: [ current ]
						ifFalse: [ best ] ]) origin +
							(anElement width @ anElement depth / 2)
							+ gap
]

{ #category : #accessing }
RWRectanglePackLayoutXZ >> boundingBox [
	^ bounds
]

{ #category : #'space-calculation' }
RWRectanglePackLayoutXZ >> extentByInserting: anExtent into: aSpace [
	| futureCorner |
	futureCorner := aSpace origin + anExtent.
	
	^	((futureCorner x - bounds x) max: 0) +
		((futureCorner y - bounds y) max: 0)
		* "this is balancing magic"
		(((futureCorner max: bounds) degrees - 45) abs / 45 + 1)


]

{ #category : #accessing }
RWRectanglePackLayoutXZ >> gap [
	
	^ gap
]

{ #category : #accessing }
RWRectanglePackLayoutXZ >> gap: anObject [
	gap := anObject / 2
]

{ #category : #initialization }
RWRectanglePackLayoutXZ >> initialize [
	super initialize.
	gap := 0.0
]

{ #category : #public }
RWRectanglePackLayoutXZ >> on: elements [
	| sortedElements |
	bounds := 0@0.
		
	sortedElements := SortedCollection sortBlock:  [ :larger :smaller |
		(larger  width + larger  depth) >
		(smaller width + smaller depth) ].
	sortedElements addAll: elements.
		
	freeSpace := Set new.
	freeSpace add: (0@0 corner: 
		(sortedElements inject: 0@0 into: [ :sum :el |
			sum + (el width @ el depth) + (gap * 2) ])).
	
	sortedElements
		do: [ :element | self packIn: element ]
		displayingProgress: 'Laying out elements'
]

{ #category : #execution }
RWRectanglePackLayoutXZ >> packIn: anElement [
	| newPosition2D base |

	newPosition2D := self bestSpaceFor: anElement.

	anElement
		translateToX: newPosition2D x
					y: anElement position y
					z: newPosition2D y.
					
	base := self yCrossSectionOf: anElement boundingBox.
	
	bounds := bounds max: base corner + gap.
	
	self recalculateFreeSpacesWith: base
]

{ #category : #'space-calculation' }
RWRectanglePackLayoutXZ >> recalculateFreeSpacesWith: aRectangle [
	freeSpace := freeSpace inject: Set new into: [ :set :space |
		 set
			addAll: (self
				areasOverlaping: space
				outsideOf: (aRectangle expandBy: gap)); 
			yourself ].
		
	"remove subspaces"
	freeSpace := freeSpace reject: [ :subspace | 
		freeSpace anySatisfy: [ :space |
			space ~~ subspace and: [ 
				space containsRect: subspace ] ] ]
	
]

{ #category : #'space-calculation' }
RWRectanglePackLayoutXZ >> yCrossSectionOf: aBox [

	^ aBox min x @ aBox min z corner:
	  aBox max x @ aBox max z
]
