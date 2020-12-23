Class {
	#name : #WCADSolidBSPFace,
	#superclass : #Object,
	#instVars : [
		'vertices',
		'plane'
	],
	#category : #'WodenEngine-CAD-CSG-BSP'
}

{ #category : #'as yet unclassified' }
WCADSolidBSPFace class >> vertices: vertices normal: normal [
	^ self new
		vertices: vertices;
		plane: (PlaneF64 normal: normal distance: (normal dot: vertices first));
		yourself
]

{ #category : #'as yet unclassified' }
WCADSolidBSPFace class >> vertices: vertices normal: normal distance: distance [
	^ self new
		vertices: vertices;
		plane: (PlaneF64 normal: normal distance: distance);
		yourself
]

{ #category : #sorting }
WCADSolidBSPFace >> fixVerticesOrientationAlongNormal [
	| expectedNormal v1 v2 v3 normal |
	v1 := vertices first.
	v2 := vertices second.
	v3 := vertices third.
	normal := (v2 - v1) cross: (v3 - v1).
	expectedNormal := plane normal.
	(normal dot: expectedNormal) < 0 ifTrue: [
		vertices := vertices reversed
	]
]

{ #category : #accessing }
WCADSolidBSPFace >> plane [

	^ plane
]

{ #category : #accessing }
WCADSolidBSPFace >> plane: anObject [

	plane := anObject
]

{ #category : #accessing }
WCADSolidBSPFace >> vertices [

	^ vertices
]

{ #category : #accessing }
WCADSolidBSPFace >> vertices: anObject [

	vertices := anObject
]
