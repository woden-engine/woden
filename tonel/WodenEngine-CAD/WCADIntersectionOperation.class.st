Class {
	#name : #WCADIntersectionOperation,
	#superclass : #WCADBooleanOperation,
	#category : #'WodenEngine-CAD-CSG'
}

{ #category : #visiting }
WCADIntersectionOperation >> accept: visitor [
	^ visitor visitIntersectionOperation: self
]

{ #category : #accessing }
WCADIntersectionOperation >> boundingBox [
	^ leftOperand boundingBox intersectionWith: rightOperand boundingBox
]

{ #category : #testing }
WCADIntersectionOperation >> isIntersectionOperation [
	^ true
]
