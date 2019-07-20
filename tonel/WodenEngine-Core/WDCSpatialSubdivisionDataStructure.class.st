Class {
	#name : #WDCSpatialSubdivisionDataStructure,
	#superclass : #Collection,
	#category : #'WodenEngine-Core-DataStructures'
}

{ #category : #'instance creation' }
WDCSpatialSubdivisionDataStructure class >> forAll: aCollection [
	| spatialObjects boundingBox |
	spatialObjects := aCollection collect: #asSpatialSubdivisionDataStructureElement.
	boundingBox := WMBox3DF empty.
	spatialObjects do: [ :el |
		boundingBox insertBox: el spatialElementBoundingBox
	].

	^ self new
		createRootNodeWithBoundingBox: boundingBox;
		addAll: spatialObjects;
		yourself
]

{ #category : #adding }
WDCSpatialSubdivisionDataStructure >> add: anElement [
	^ self addSpatialSubdivisionDataStructureElement: anElement asSpatialSubdivisionDataStructureElement
]

{ #category : #adding }
WDCSpatialSubdivisionDataStructure >> addBox: aBox [
	^ self add: (WDCSpatialSubdivisionDataStructureBoxElement new value: aBox).

]

{ #category : #adding }
WDCSpatialSubdivisionDataStructure >> addBoxes: aCollectionOfBoxes [
	aCollectionOfBoxes do: [ :box |
		self add: (WDCSpatialSubdivisionDataStructureBoxElement new value: box).
	]

]

{ #category : #adding }
WDCSpatialSubdivisionDataStructure >> addPoint: aPoint [
	^ self add: (WDCSpatialSubdivisionDataStructurePointElement new value: aPoint).

]

{ #category : #adding }
WDCSpatialSubdivisionDataStructure >> addPoints: aCollectionOfPoints [
	aCollectionOfPoints do: [ :point |
		self add: (WDCSpatialSubdivisionDataStructurePointElement new value: point).
	]

]

{ #category : #adding }
WDCSpatialSubdivisionDataStructure >> addSpatialSubdivisionDataStructureElement: anElement [
	self subclassResponsibility
]

{ #category : #enumerating }
WDCSpatialSubdivisionDataStructure >> allElementsInsideOfBox: box [
	^ self allElementsInsideOfBox: box select: [:el | true] thenCollect: #yourself
]

{ #category : #enumerating }
WDCSpatialSubdivisionDataStructure >> allElementsInsideOfBox: box do: aBlock [
	self subclassResponsibility
]

{ #category : #enumerating }
WDCSpatialSubdivisionDataStructure >> allElementsInsideOfBox: box select: selectBlock thenCollect: aBlock [
	| result |
	result := OrderedCollection new.
	self allElementsInsideOfBox: box do: [ :el |
		(selectBlock value: el) ifTrue: [ 
			result add: (aBlock value: el)
		]
	].
	^ result
]

{ #category : #enumerating }
WDCSpatialSubdivisionDataStructure >> allElementsInsideOfBox: box thenCollect: aBlock [
	^ self allElementsIntersectingBox: box select: [:el | true] thenCollect: aBlock
]

{ #category : #enumerating }
WDCSpatialSubdivisionDataStructure >> allElementsIntersectingBox: box [
	^ self allElementsIntersectingBox: box select: [:el | true] thenCollect: #yourself
]

{ #category : #enumerating }
WDCSpatialSubdivisionDataStructure >> allElementsIntersectingBox: box do: aBlock [
	self subclassResponsibility
]

{ #category : #enumerating }
WDCSpatialSubdivisionDataStructure >> allElementsIntersectingBox: box select: selectBlock thenCollect: aBlock [
	| result |
	result := OrderedCollection new.
	self allElementsIntersectingBox: box do: [ :el |
		(selectBlock value: el) ifTrue: [ 
			result add: (aBlock value: el)
		]
	].
	^ result
]

{ #category : #enumerating }
WDCSpatialSubdivisionDataStructure >> allElementsIntersectingBox: box thenCollect: aBlock [
	^ self allElementsIntersectingBox: box select: [:el | true] thenCollect: aBlock
]

{ #category : #accessing }
WDCSpatialSubdivisionDataStructure >> size [
	self subclassResponsibility 
]
