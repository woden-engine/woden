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
	box := BoxF32 unitBox.
	self assert: collection isEmpty.
	collection addBox: box.
	
	self assert: collection size equals: 1.
	self assert: collection asArray equals: { box }.
	
	self assert: (collection allElementsInsideOfBox: (BoxF32 center: Float32x3 ones * 2.0 halfExtent: Float32x3 ones)) isEmpty.
	self assert: (collection allElementsIntersectingBox: (BoxF32 center: Float32x3 ones * 2.0 halfExtent: Float32x3 ones)) isEmpty.

	self assert: (collection allElementsInsideOfBox: BoxF32 unitBox) asArray equals: { box }.
	self assert: (collection allElementsIntersectingBox: BoxF32 unitBox) asArray equals: { box }.

	self assert: (collection allElementsInsideOfBox: (BoxF32 halfExtent: Float32x3 ones * 0.25)) asArray isEmpty.
	self assert: (collection allElementsIntersectingBox: (BoxF32 halfExtent: Float32x3 ones * 0.25)) asArray equals: { box }.
]

{ #category : #tests }
WDCSpatialSubdivisionDataStructureTest >> testAddPoint [
	| collection point |
	collection := dataStructureClass new.
	point := Float32x3 x: 1.0 y: 2.0 z: 3.0.
	self assert: collection isEmpty.
	collection addPoint: point.
	
	self assert: collection size equals: 1.
	self assert: collection asArray equals: { point }.
	
	self assert: (collection allElementsInsideOfBox: BoxF32 unitBox) isEmpty.
	self assert: (collection allElementsIntersectingBox: BoxF32 unitBox) isEmpty.
	self assert: (collection allElementsInsideOfBox: (BoxF32 halfExtent: (Float32x3 x: 3.0 y: 3.0 z: 3.0))) asArray equals: { point }.
	self assert: (collection allElementsIntersectingBox: (BoxF32 halfExtent: (Float32x3 x: 3.0 y: 3.0 z: 3.0))) asArray equals: { point }.
]

{ #category : #tests }
WDCSpatialSubdivisionDataStructureTest >> testAddTwoPoints [
	| collection firstPoint secondPoint |
	collection := dataStructureClass new.
	firstPoint := Float32x3 zeros.
	secondPoint := Float32x3 x: 1.0 y: 2.0 z: 3.0.
	self assert: collection isEmpty.
	collection addPoints: { firstPoint . secondPoint }.
	
	self assert: collection size equals: 2.
	
	self assert: (collection allElementsInsideOfBox: BoxF32 unitBox) asArray equals: { firstPoint }.
	self assert: (collection allElementsIntersectingBox: BoxF32 unitBox) asArray equals: { firstPoint }.

	self assert: (collection allElementsInsideOfBox: (BoxF32 halfExtent: (Float32x3 x: 3.0 y: 3.0 z: 3.0))) size equals: 2.
	self assert: (collection allElementsIntersectingBox: (BoxF32 halfExtent: (Float32x3 x: 3.0 y: 3.0 z: 3.0))) size equals: 2.
]

{ #category : #tests }
WDCSpatialSubdivisionDataStructureTest >> testNew [
	| collection |
	collection := dataStructureClass new.
	self assert: collection isEmpty.
]
