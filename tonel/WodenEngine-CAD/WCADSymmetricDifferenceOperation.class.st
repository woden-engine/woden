Class {
	#name : #WCADSymmetricDifferenceOperation,
	#superclass : #WCADBooleanOperation,
	#category : #'WodenEngine-CAD-CSG'
}

{ #category : #visiting }
WCADSymmetricDifferenceOperation >> accept: visitor [
	^ visitor visitSymmetricDifferenceOperation: self
]

{ #category : #accessing }
WCADSymmetricDifferenceOperation >> boundingBox [
	^ leftOperand boundingBox unionWithBox: rightOperand boundingBox
]

{ #category : #accessing }
WCADSymmetricDifferenceOperation >> isSymmetricDifferenceOperation [
	^ true
]
