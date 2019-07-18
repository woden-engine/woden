Class {
	#name : #WDCSpatialBag,
	#superclass : #WDCSpatialSubdivisionDataStructure,
	#instVars : [
		'elements'
	],
	#category : #'WodenEngine-Core-DataStructures'
}

{ #category : #adding }
WDCSpatialBag >> addSpatialSubdivisionDataStructureElement: anElement [
	elements add: anElement
]

{ #category : #enumerating }
WDCSpatialBag >> allElementsInsideOfBox: box do: aBlock [
	elements do: [ :element |
		(element isSpatialElementInsideOfBox: box) ifTrue: [
			aBlock value: element spatialElementValue
		]
	]
]

{ #category : #enumerating }
WDCSpatialBag >> allElementsIntersectingBox: box do: aBlock [
	elements do: [ :element |
		(element isSpatialElementIntersectingBox: box) ifTrue: [
			aBlock value: element spatialElementValue
		]
	]
]

{ #category : #enumerating }
WDCSpatialBag >> do: aBlock [
	elements do: [ :el | aBlock value: (el spatialElementValue) ]
]

{ #category : #initialization }
WDCSpatialBag >> initialize [
	super initialize.
	elements := OrderedCollection new.
]

{ #category : #removing }
WDCSpatialBag >> remove: oldObject ifAbsent: anExceptionBlock [
	^ elements remove: oldObject ifAbsent: anExceptionBlock
]

{ #category : #accessing }
WDCSpatialBag >> size [
	^ elements size
]
