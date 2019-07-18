Class {
	#name : #WDCQuadTreeNode,
	#superclass : #Object,
	#instVars : [
		'tree',
		'maxDepth',
		'boundingBox',
		'children',
		'elements'
	],
	#category : #'WodenEngine-Core-DataStructures'
}

{ #category : #adding }
WDCQuadTreeNode >> addElement: anElement [
	^ anElement isSpatialVolumeElement
		ifTrue: [ self addVolumeElement: anElement ]
		ifFalse: [ self addPointElement: anElement ]
]

{ #category : #adding }
WDCQuadTreeNode >> addPointElement: anElement [
	self assert: (anElement isSpatialElementStrictlyInsideOfBox: boundingBox).
	self isLeaf ifTrue: [
		self validElementsOrderedCollection add: anElement.
		^ self checkSplitCondition
	].

	children do: [ :child |
		(anElement isSpatialElementStrictlyInsideOfBox: child boundingBox) ifTrue: [
			^ child addPointElement: anElement
		]
	].

	self error: 'Invalid point. Cannot add to child node.'
]

{ #category : #adding }
WDCQuadTreeNode >> addVolumeElement: anElement [
	self assert: (anElement isSpatialElementStrictlyInsideOfBox: boundingBox).
	self isLeaf ifTrue: [
		self validElementsOrderedCollection add: anElement.
		^ self checkSplitCondition
	].

	children do: [ :child |
		(anElement isSpatialElementInsideOfBox: child boundingBox) ifTrue: [
			^ child addVolumeElement: anElement
		].
	].

	self validElementsOrderedCollection add: anElement.
	^ self

]

{ #category : #enumerating }
WDCQuadTreeNode >> allElementsInsideOfBox: box do: aBlock [
	elements ifNotNil: [
		elements do: [ :element |
			(element isSpatialElementInsideOfBox: box) ifTrue: [
				aBlock value: element
			]
		]
	].
	
	children do: [ :child |
		| childBox |
		childBox := child boundingBox.
		(box intersectsOrContainsBox: childBox) ifTrue: [ 
			(box includesBox: childBox) ifTrue: [ 
				child do: aBlock
			] ifFalse: [
				child allElementsInsideOfBox: box do: aBlock
			]
		].
	]
]

{ #category : #enumerating }
WDCQuadTreeNode >> allElementsIntersectingBox: box do: aBlock [
	elements ifNotNil: [
		elements do: [ :element |
			(element isSpatialElementIntersectingBox: box) ifTrue: [
				aBlock value: element
			]
		]
	].
	
	children do: [ :child |
		| childBox |
		childBox := child boundingBox.
		(box intersectsOrContainsBox: childBox) ifTrue: [ 
			(box includesBox: childBox) ifTrue: [ 
				child do: aBlock
			] ifFalse: [
				child allElementsIntersectingBox: box do: aBlock
			]
		].
	]
]

{ #category : #accessing }
WDCQuadTreeNode >> boundingBox [
	^ boundingBox
]

{ #category : #accessing }
WDCQuadTreeNode >> boundingBox: anObject [
	boundingBox := anObject
]

{ #category : #'as yet unclassified' }
WDCQuadTreeNode >> checkSplitCondition [
	self assert: self isLeaf.
	elements ifNil: [ ^ self ].
	maxDepth <= 0 ifTrue: [ ^ self ].
	elements size < self nodeSplitCountThreshold ifTrue: [ ^ self ].
	self splitNode
]

{ #category : #accessing }
WDCQuadTreeNode >> children [
	^ children
]

{ #category : #'as yet unclassified' }
WDCQuadTreeNode >> createChildrenNodes [
	^ boundingBox quadrants collect: [ :octant |
		self class new
			boundingBox: octant;
			maxDepth: maxDepth - 1;
			yourself.
	].
]

{ #category : #enumerating }
WDCQuadTreeNode >> do: aBlock [
	elements ifNotNil: [ elements do: aBlock ].
	children do: [ :child | child do: aBlock ]
]

{ #category : #accessing }
WDCQuadTreeNode >> elements [
	^ elements ifNil: [ #() ]
]

{ #category : #initialization }
WDCQuadTreeNode >> initialize [
	super initialize.
	children := #().
]

{ #category : #initialization }
WDCQuadTreeNode >> isLeaf [
	^ children isEmpty
]

{ #category : #accessing }
WDCQuadTreeNode >> maxDepth [
	^ maxDepth
]

{ #category : #accessing }
WDCQuadTreeNode >> maxDepth: anObject [
	maxDepth := anObject
]

{ #category : #'as yet unclassified' }
WDCQuadTreeNode >> nodeSplitCountThreshold [
	^ tree nodeSplitCountThreshold
]

{ #category : #'as yet unclassified' }
WDCQuadTreeNode >> splitNode [
	| oldElements |
	self assert: self isLeaf.
	self assert: maxDepth > 0.
	
	children := self createChildrenNodes.
	oldElements := elements.
	elements := nil.
	oldElements do: [ :element |
		self addElement: element
	].

]

{ #category : #accessing }
WDCQuadTreeNode >> tree [
	^ tree
]

{ #category : #accessing }
WDCQuadTreeNode >> tree: anObject [
	tree := anObject
]

{ #category : #adding }
WDCQuadTreeNode >> validElementsOrderedCollection [
	^ elements ifNil: [ elements := OrderedCollection new ]
]
