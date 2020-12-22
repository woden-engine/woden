"
I represent a single box shape.
"
Class {
	#name : #WCADBox,
	#superclass : #WCADBasicSolid,
	#instVars : [
		'extent'
	],
	#category : #'WodenEngine-CAD-CSG'
}

{ #category : #visiting }
WCADBox >> accept: visitor [
	^ visitor visitBox: self
]

{ #category : #accessing }
WCADBox >> boundingBox [
	^ BoxF64 halfExtent: extent / 2
]

{ #category : #accessing }
WCADBox >> depth: width [
	extent z: width
]

{ #category : #accessing }
WCADBox >> extent [

	^ extent
]

{ #category : #accessing }
WCADBox >> extent: anObject [
	extent := anObject castTo: Float64x3
]

{ #category : #accessing }
WCADBox >> height: width [
	extent y: width
]

{ #category : #initialization }
WCADBox >> initialize [
	super initialize.
	extent := Float64x3 ones.
]

{ #category : #testing }
WCADBox >> isBox [
	^ true
]

{ #category : #accessing }
WCADBox >> width: width [
	extent x: width
]
