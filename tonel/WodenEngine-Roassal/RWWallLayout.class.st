"
I lay out elements into a way (like 4 walls of a room concidered together).

#gap parameter sets the distance between elements in the layout.

Implementation taken from CodeCity http://codecity.inf.usi.ch/
"
Class {
	#name : #RWWallLayout,
	#superclass : #RWLayout,
	#instVars : [
		'gap'
	],
	#category : #'WodenEngine-Roassal-Layout'
}

{ #category : #'position calculation' }
RWWallLayout >> computeMaximumDimension: nodes [
	^ (nodes
		inject: Float32x3 zeros
		into: [ :maxiumDimension :each |
			| boundingBoxDimension |
			boundingBoxDimension := each extent.
			maxiumDimension
				x: (maxiumDimension x max: boundingBoxDimension x);
				y: (maxiumDimension y max: boundingBoxDimension y);
				z: (maxiumDimension z max: boundingBoxDimension z);
				yourself ]) + (Float32x3 x: gap y: gap z: gap)
]

{ #category : #'dimension calculation' }
RWWallLayout >> elementsPerLayerForElementsPerSide: elementsPerSide [
	^ elementsPerSide == 1
		ifTrue: [ 1 ]
		ifFalse: [ 4 * (elementsPerSide - 1) ]
]

{ #category : #'dimension calculation' }
RWWallLayout >> elementsPerSideForElements: numberOfElements [
	| elementsPerSide |
	self assert: numberOfElements >= 0.
	elementsPerSide := 1.
	[ 
	| min max |
	min := self minimumNumberOfElementsForElementsPerSide: elementsPerSide.
	max := self maximumNumberOfElementsForElementsPerSide: elementsPerSide.
	numberOfElements >= min and: [ numberOfElements <= max ] ] whileFalse: [ elementsPerSide := elementsPerSide + 1 ].
	^ elementsPerSide
]

{ #category : #accessing }
RWWallLayout >> gap [
	^ gap
]

{ #category : #accessing }
RWWallLayout >> gap: anObject [
	gap := anObject asFloat.
]

{ #category : #initialization }
RWWallLayout >> initialize [
	gap := 0.0
]

{ #category : #'dimension calculation' }
RWWallLayout >> maximumNumberOfElementsForElementsPerSide: elementsPerSide [
	| nextMinimum |
	nextMinimum := self minimumNumberOfElementsForElementsPerSide: elementsPerSide + 1.
	^ nextMinimum - 1
]

{ #category : #'dimension calculation' }
RWWallLayout >> minimumNumberOfElementsForElementsPerSide: elementsPerSide [
	| elementsPerLayer minimumNumberOfLayers |
	elementsPerLayer := self elementsPerLayerForElementsPerSide: elementsPerSide.
	minimumNumberOfLayers := self minimumNumberOfLayersForElementsPerSide: elementsPerSide.
	^ minimumNumberOfLayers * elementsPerLayer
]

{ #category : #'dimension calculation' }
RWWallLayout >> minimumNumberOfLayersForElementsPerSide: elementsPerSide [
	^ (elementsPerSide - 1) * 2
]

{ #category : #public }
RWWallLayout >> on: aCollection [
	| elemenets bricksPerSide maxDimension positions layer actionBlock bricksInLayer |
	elemenets := aCollection asOrderedCollection.
	bricksPerSide := self elementsPerSideForElements: elemenets size.
	bricksInLayer := (bricksPerSide - 1) * 4 max: 1.
	maxDimension := self computeMaximumDimension: elemenets.
	positions := self
		positionsFor: maxDimension
		onLayerSized: bricksPerSide.
	
	layer := 0.	
	actionBlock := [ :el :index |
		el
			translateToX: (positions at: index) x
			           y: layer * maxDimension y
			           z: (positions at: index) y ].
	
	elemenets
		groupsOf: bricksInLayer
		atATimeDo: [ :els | 
			els withIndexDo: actionBlock.
			layer := layer + 1 ].
	(elemenets allButFirst: layer * bricksInLayer) withIndexDo: actionBlock
]

{ #category : #'position calculation' }
RWWallLayout >> positionsFor: aDimension onLayerSized: aNumber [
	| positions corner partSize |
	aNumber = 1 ifTrue: [ ^ { 0 @ 0 } ].
	
	partSize := aNumber - 1.
	positions := OrderedCollection new: partSize * 4.
	
	corner := aDimension x @ aDimension z * partSize / 2.
	
	
	{ aDimension x negated @ 0 .
	                     0 @ aDimension z negated .
	          aDimension x @ 0 .
	                     0 @ aDimension z } do: [ :shift |
		
		partSize timesRepeat: [
			positions add: corner.
			corner := corner + shift ]].
	
	
	^ positions asArray
]
