"
I represent a single sphere.
"
Class {
	#name : #WCADSphere,
	#superclass : #WCADBasicSolid,
	#instVars : [
		'radius'
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

{ #category : #initialization }
WCADSphere >> initialize [
	super initialize.
	radius := 1.0.
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
