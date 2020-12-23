"
I am an ellipsoid shape.
"
Class {
	#name : #WCADEllipsoid,
	#superclass : #WCADBasicSolid,
	#instVars : [
		'radiuses',
		'subdivisions'
	],
	#category : #'WodenEngine-CAD-CSG'
}

{ #category : #visiting }
WCADEllipsoid >> accept: visitor [
	^ visitor visitEllipsoid: self
]

{ #category : #accessing }
WCADEllipsoid >> boundingBox [
	^ BoxF64 halfExtent: radiuses
]

{ #category : #accessing }
WCADEllipsoid >> diameters [
	^ radiuses * 2
]

{ #category : #accessing }
WCADEllipsoid >> diameters: newDiameters [
	self radiuses: newDiameters / 2
]

{ #category : #initialization }
WCADEllipsoid >> initialize [
	super initialize.
	radiuses := Float64x3 ones.
	subdivisions := 1.
]

{ #category : #testing }
WCADEllipsoid >> isEllipsoid [
	^ true
]

{ #category : #accessing }
WCADEllipsoid >> radiuses [

	^ radiuses
]

{ #category : #accessing }
WCADEllipsoid >> radiuses: anObject [

	radiuses := anObject castTo: Float64x3
]

{ #category : #accessing }
WCADEllipsoid >> subdivisions [

	^ subdivisions
]

{ #category : #accessing }
WCADEllipsoid >> subdivisions: anObject [

	subdivisions := anObject
]
