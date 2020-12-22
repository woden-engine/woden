Class {
	#name : #WCADDifferenceOperation,
	#superclass : #WCADBooleanOperation,
	#category : #'WodenEngine-CAD-CSG'
}

{ #category : #visiting }
WCADDifferenceOperation >> accept: visitor [
	^ visitor visitDifferenceOperation: self
]

{ #category : #accessing }
WCADDifferenceOperation >> boundingBox [
	^ leftOperand boundingBox
]

{ #category : #testing }
WCADDifferenceOperation >> isDifferenceOperation [
	^ true
]
