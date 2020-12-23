"
I represent a single sphere.
"
Class {
	#name : #WCADSphere,
	#superclass : #WCADBasicSolid,
	#instVars : [
		'radius',
		'subdivisions'
	],
	#category : #'WodenEngine-CAD-CSG'
}

{ #category : #visiting }
WCADSphere >> accept: visitor [
	^ visitor visitSphere: self
]

{ #category : #accessing }
WCADSphere >> boundingBox [
	^ BoxF64 halfExtent: radius
]

{ #category : #accessing }
WCADSphere >> diameter [

	^ radius * 2
]

{ #category : #accessing }
WCADSphere >> diameter: diameter [
	self radius: diameter / 2
]

{ #category : #initialization }
WCADSphere >> initialize [
	super initialize.
	radius := 1.0.
	subdivisions := 1.
]

{ #category : #testing }
WCADSphere >> isBox [
	^ true
]

{ #category : #accessing }
WCADSphere >> radius [

	^ radius
]

{ #category : #accessing }
WCADSphere >> radius: anObject [

	radius := anObject
]

{ #category : #accessing }
WCADSphere >> subdivisions [

	^ subdivisions
]

{ #category : #accessing }
WCADSphere >> subdivisions: anObject [

	subdivisions := anObject
]
