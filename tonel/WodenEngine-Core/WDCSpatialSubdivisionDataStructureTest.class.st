"
A WDCSpatialSubdivisionDataStructureTest is a test class for testing the behavior of WDCSpatialSubdivisionDataStructure
"
Class {
	#name : #WDCSpatialSubdivisionDataStructureTest,
	#superclass : #TestCase,
	#instVars : [
		'dataStructureClass'
	],
	#category : #'WodenEngine-Core-Tests'
}

{ #category : #testing }
WDCSpatialSubdivisionDataStructureTest class >> isAbstract [
	^ self == WDCSpatialSubdivisionDataStructureTest
]

{ #category : #running }
WDCSpatialSubdivisionDataStructureTest >> dataStructureClass [
	self subclassResponsibility
]

{ #category : #running }
WDCSpatialSubdivisionDataStructureTest >> setUp [
	dataStructureClass := self dataStructureClass
]

{ #category : #tests }
WDCSpatialSubdivisionDataStructureTest >> testAddBox [
	| collection box |
	collection := dataStructureClass new.
	box := WMBox3DF unitCube.
	self assert: collection isEmpty.
	collection addBox: box.
	
	self assert: collection size equals: 1.
	self assert: collection asArray equals: { box }.
	
	self assert: (collection allElementsInsideOfBox: (WMBox3DF halfExtent: WMVector3F ones center: WMVector3F ones * 2.0)) isEmpty.
	self assert: (collection allElementsIntersectingBox: (WMBox3DF halfExtent: WMVector3F ones center: WMVector3F ones * 2.0 )) isEmpty.

	self assert: (collection allElementsInsideOfBox: WMBox3DF unitCube) asArray equals: { box }.
	self assert: (collection allElementsIntersectingBox: WMBox3DF unitCube) asArray equals: { box }.

	self assert: (collection allElementsInsideOfBox: (WMBox3DF halfExtent: WMVector3F ones * 0.25)) asArray isEmpty.
	self assert: (collection allElementsIntersectingBox: (WMBox3DF halfExtent: WMVector3F ones * 0.25)) asArray equals: { box }.
]

{ #category : #tests }
WDCSpatialSubdivisionDataStructureTest >> testAddPoint [
	| collection point |
	collection := dataStructureClass new.
	point := WMVector3F x: 1.0 y: 2.0 z: 3.0.
	self assert: collection isEmpty.
	collection addPoint: point.
	
	self assert: collection size equals: 1.
	self assert: collection asArray equals: { point }.
	
	self assert: (collection allElementsInsideOfBox: WMBox3DF unitCube) isEmpty.
	self assert: (collection allElementsIntersectingBox: WMBox3DF unitCube) isEmpty.
	self assert: (collection allElementsInsideOfBox: (WMBox3DF halfExtent: (WMVector3F x: 3.0 y: 3.0 z: 3.0))) asArray equals: { point }.
	self assert: (collection allElementsIntersectingBox: (WMBox3DF halfExtent: (WMVector3F x: 3.0 y: 3.0 z: 3.0))) asArray equals: { point }.
]

{ #category : #tests }
WDCSpatialSubdivisionDataStructureTest >> testAddTwoPoints [
	| collection firstPoint secondPoint |
	collection := dataStructureClass new.
	firstPoint := WMVector3F zero.
	secondPoint := WMVector3F x: 1.0 y: 2.0 z: 3.0.
	self assert: collection isEmpty.
	collection addPoints: { firstPoint . secondPoint }.
	
	self assert: collection size equals: 2.
	
	self assert: (collection allElementsInsideOfBox: WMBox3DF unitCube) asArray equals: { firstPoint }.
	self assert: (collection allElementsIntersectingBox: WMBox3DF unitCube) asArray equals: { firstPoint }.

	self assert: (collection allElementsInsideOfBox: (WMBox3DF halfExtent: (WMVector3F x: 3.0 y: 3.0 z: 3.0))) size equals: 2.
	self assert: (collection allElementsIntersectingBox: (WMBox3DF halfExtent: (WMVector3F x: 3.0 y: 3.0 z: 3.0))) size equals: 2.
]

{ #category : #tests }
WDCSpatialSubdivisionDataStructureTest >> testNew [
	| collection |
	collection := dataStructureClass new.
	self assert: collection isEmpty.
]
