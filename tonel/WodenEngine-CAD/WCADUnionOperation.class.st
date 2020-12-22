Class {
	#name : #WCADUnionOperation,
	#superclass : #WCADBooleanOperation,
	#category : #'WodenEngine-CAD-CSG'
}

{ #category : #visiting }
WCADUnionOperation >> accept: visitor [
	^ visitor visitUnionOperation: self
]

{ #category : #accessing }
WCADUnionOperation >> boundingBox [
	^ leftOperand boundingBox unionWithBox: rightOperand boundingBox
]

{ #category : #testing }
WCADUnionOperation >> isUnionOperation [
	^ true
]
