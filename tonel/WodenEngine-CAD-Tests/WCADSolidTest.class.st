"
A WCADSolidTest is a test class for testing the behavior of WCADSolid
"
Class {
	#name : #WCADSolidTest,
	#superclass : #TestCase,
	#category : #'WodenEngine-CAD-Tests-CSG'
}

{ #category : #tests }
WCADSolidTest >> testBox [
	| box |
	box := WCADSolid box
		width: 2;
		height: 3;	
		depth: 4;
		yourself.
	self assert: box isBasicSolid.
	self assert: box extent equals: (Float64x3 x: 2 y: 3 z: 4).

	self assert: box width equals: 2.
	self assert: box height equals: 3.
	self assert: box depth equals: 4.
]

{ #category : #tests }
WCADSolidTest >> testBoxComplement [
	| box boxComplement |
	box := WCADSolid box.
	self assert: box boundingBox extent equals: Float64x3 ones.
	
	boxComplement := box complement.
	self assert: boxComplement boundingBox equals: BoxF64 fullSpace.
	self assert: box complement complement equals: box
]

{ #category : #tests }
WCADSolidTest >> testDefaultBox [
	| box |
	box := WCADSolid box.
	self assert: box isBasicSolid.
	self assert: box extent equals: Float64x3 ones.

	self assert: box width equals: 1.
	self assert: box height equals: 1.
	self assert: box depth equals: 1.
]

{ #category : #tests }
WCADSolidTest >> testDefaultEllipsoid [
	| ellipsoid |
	ellipsoid := WCADSolid ellipsoid.
	self assert: ellipsoid isBasicSolid.
	self assert: ellipsoid isEllipsoid.
	self assert: ellipsoid radiuses equals: Float64x3 ones.
]

{ #category : #tests }
WCADSolidTest >> testDefaultSphere [
	| sphere |
	sphere := WCADSolid sphere.
	self assert: sphere isBasicSolid.
	self assert: sphere radius equals: 1.
	
]

{ #category : #tests }
WCADSolidTest >> testDifference [
	| leftBox rightBox difference |
	leftBox := WCADSolid box width: 3.0; height: 3.0; translatedByX: -1.
	rightBox := WCADSolid box width: 3.0; height: 1.0; translatedByX: 1.
	difference := leftBox difference: rightBox.
	
	self assert: difference isOperation.
	self assert: difference isDifferenceOperation.
	self assert: difference boundingBox equals: leftBox boundingBox

]

{ #category : #tests }
WCADSolidTest >> testDifference2 [
	| leftBox rightBox difference |
	leftBox := WCADSolid box width: 3.0; height: 3.0; translatedByX: -1.
	rightBox := WCADSolid box width: 3.0; height: 1.0; translatedByX: 1.
	difference := leftBox - rightBox.
	
	self assert: difference isOperation.
	self assert: difference isDifferenceOperation.
	self assert: difference boundingBox equals: leftBox boundingBox

]

{ #category : #tests }
WCADSolidTest >> testEllipsoid [
	| ellipsoid |
	ellipsoid := WCADSolid ellipsoid
		diameters: (Float64x3 x: 2 y: 3 z: 4);
		yourself.
	self assert: ellipsoid isBasicSolid.
	self assert: ellipsoid diameters equals: (Float64x3 x: 2 y: 3 z: 4).

	self assert: ellipsoid width equals: 2.
	self assert: ellipsoid height equals: 3.
	self assert: ellipsoid depth equals: 4.
]

{ #category : #tests }
WCADSolidTest >> testIntersection [
	| leftBox rightBox intersection |
	leftBox := WCADSolid box width: 3.0; height: 3.0; translatedByX: -1.
	rightBox := WCADSolid box width: 3.0; height: 1.0; translatedByX: 1.
	intersection := leftBox intersection: rightBox.
	
	self assert: intersection isOperation.
	self assert: intersection isIntersectionOperation.
	self assert: intersection boundingBox extent equals: Float64x3 ones.
	self assert: intersection boundingBox center equals: Float64x3 zeros.

]

{ #category : #tests }
WCADSolidTest >> testIntersection2 [
	| leftBox rightBox intersection |
	leftBox := WCADSolid box width: 3.0; height: 3.0; translatedByX: -1.
	rightBox := WCADSolid box width: 3.0; height: 1.0; translatedByX: 1.
	intersection := leftBox & rightBox.
	
	self assert: intersection isOperation.
	self assert: intersection isIntersectionOperation.
	self assert: intersection boundingBox extent equals: Float64x3 ones.
	self assert: intersection boundingBox center equals: Float64x3 zeros.

]

{ #category : #tests }
WCADSolidTest >> testMultipleTranslatedBy [
	| box |
	box := WCADSolid box.
	box := box translatedByX: 1.
	box := box translatedByY: 2.
	box := box translatedByZ: 3.
	
	self assert: box isOperation.
	self assert: box isTransformOperation.
	self assert: box boundingBox extent equals: Float64x3 ones.
	self assert: box boundingBox center equals: (Float64x3 x: 1 y: 2 z: 3).
	self assert: box translation equals: (Float64x3 x: 1 y: 2 z: 3).
]

{ #category : #tests }
WCADSolidTest >> testSphere [
	| sphere |
	sphere := WCADSolid sphere radius: 3.0.
	self assert: sphere isBasicSolid.
	self assert: sphere radius equals: 3.0.
	self assert: sphere width equals: 6.0.
	self assert: sphere height equals: 6.0.
	self assert: sphere depth equals: 6.0.

]

{ #category : #tests }
WCADSolidTest >> testSymmetricDifference [
	| leftBox rightBox difference |
	leftBox := WCADSolid box width: 3.0; height: 3.0; translatedByX: -1.
	rightBox := WCADSolid box width: 3.0; height: 1.0; translatedByX: 1.
	difference := leftBox symmetricDifference: rightBox.
	
	self assert: difference isOperation.
	self assert: difference isSymmetricDifferenceOperation.
	self assert: difference boundingBox equals: (leftBox boundingBox unionWith: rightBox boundingBox).

]

{ #category : #tests }
WCADSolidTest >> testTranslatedBy [
	| translatedBox |
	translatedBox := WCADSolid box translatedBy: (Float64x3 x: 1 y: 2 z: 3).
	self assert: translatedBox isOperation.
	self assert: translatedBox isTransformOperation.
	self assert: translatedBox boundingBox extent equals: Float64x3 ones.
	self assert: translatedBox boundingBox center equals: (Float64x3 x: 1 y: 2 z: 3).
]

{ #category : #tests }
WCADSolidTest >> testTranslatedByX [
	| translatedBox |
	translatedBox := WCADSolid box translatedByX: 1.
	self assert: translatedBox isOperation.
	self assert: translatedBox isTransformOperation.
	self assert: translatedBox boundingBox extent equals: Float64x3 ones.
	self assert: translatedBox boundingBox center equals: (Float64x3 x: 1).
]

{ #category : #tests }
WCADSolidTest >> testTranslatedByY [
	| translatedBox |
	translatedBox := WCADSolid box translatedByY: 1.
	self assert: translatedBox isOperation.
	self assert: translatedBox isTransformOperation.
	self assert: translatedBox boundingBox extent equals: Float64x3 ones.
	self assert: translatedBox boundingBox center equals: (Float64x3 y: 1).
]

{ #category : #tests }
WCADSolidTest >> testTranslatedByZ [
	| translatedBox |
	translatedBox := WCADSolid box translatedByZ: 1.
	self assert: translatedBox isOperation.
	self assert: translatedBox isTransformOperation.
	self assert: translatedBox boundingBox extent equals: Float64x3 ones.
	self assert: translatedBox boundingBox center equals: (Float64x3 z: 1).
]

{ #category : #tests }
WCADSolidTest >> testUnion [
	| leftBox rightBox union|
	leftBox := WCADSolid box width: 2.0; height: 3.0; translatedByX: -1.
	rightBox := WCADSolid box width: 2.0; height: 1.0; translatedByX: 1.
	union := leftBox union: rightBox.
	
	self assert: union isOperation.
	self assert: union isUnionOperation.
	self assert: union boundingBox extent equals: (Float64x3 x: 4 y: 3 z: 1).
	self assert: union boundingBox center equals: Float64x3 zeros.

]

{ #category : #tests }
WCADSolidTest >> testUnion2 [
	| leftBox rightBox union|
	leftBox := WCADSolid box width: 2.0; height: 3.0; translatedByX: -1.
	rightBox := WCADSolid box width: 2.0; height: 1.0; translatedByX: 1.
	union := leftBox | rightBox.
	
	self assert: union isOperation.
	self assert: union isUnionOperation.
	self assert: union boundingBox extent equals: (Float64x3 x: 4 y: 3 z: 1).
	self assert: union boundingBox center equals: Float64x3 zeros.

]
