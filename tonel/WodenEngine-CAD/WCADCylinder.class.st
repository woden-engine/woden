Class {
	#name : #WCADCylinder,
	#superclass : #WCADBasicSolid,
	#instVars : [
		'length',
		'radius',
		'slices'
	],
	#category : #'WodenEngine-CAD-CSG'
}

{ #category : #accessing }
WCADCylinder >> diameter [
	^ radius * 2
]

{ #category : #accessing }
WCADCylinder >> diameter: newDiameter [
	self radius: newDiameter / 2
]

{ #category : #initialization }
WCADCylinder >> initialize [
	super initialize.
	slices := 16.
	length := 1.
	radius := 1.
]

{ #category : #testing }
WCADCylinder >> isCylinder [
	^ true
]

{ #category : #accessing }
WCADCylinder >> length [

	^ length
]

{ #category : #accessing }
WCADCylinder >> length: anObject [

	length := anObject implicitCastTo: Float64
]

{ #category : #accessing }
WCADCylinder >> radius [

	^ radius
]

{ #category : #accessing }
WCADCylinder >> radius: anObject [

	radius := anObject implicitCastTo: Float64
]

{ #category : #accessing }
WCADCylinder >> slices [

	^ slices
]

{ #category : #accessing }
WCADCylinder >> slices: anObject [

	slices := anObject
]
