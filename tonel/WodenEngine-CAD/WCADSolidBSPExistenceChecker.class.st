Class {
	#name : #WCADSolidBSPExistenceChecker,
	#superclass : #WCADSolidVisitor,
	#category : #'WodenEngine-CAD-CSG-BSP'
}

{ #category : #visiting }
WCADSolidBSPExistenceChecker >> visitBasicSolid: solid [
	^ false
]

{ #category : #visiting }
WCADSolidBSPExistenceChecker >> visitBooleanOperation: node [
	^ (self visitSolid: node leftOperand) and: [ self visitSolid: node rightOperand ]
]

{ #category : #visiting }
WCADSolidBSPExistenceChecker >> visitBox: box [
	^ true
]

{ #category : #visiting }
WCADSolidBSPExistenceChecker >> visitComplementOperation: node [
	^ true
]

{ #category : #visiting }
WCADSolidBSPExistenceChecker >> visitCylinder: cylinder [
	^ true
]

{ #category : #visiting }
WCADSolidBSPExistenceChecker >> visitEllipsoid: box [
	^ true
]

{ #category : #visiting }
WCADSolidBSPExistenceChecker >> visitOperation: node [
	^ false
]

{ #category : #visiting }
WCADSolidBSPExistenceChecker >> visitSphere: solid [
	^ true
]

{ #category : #visiting }
WCADSolidBSPExistenceChecker >> visitTransformOperation: node [
	^ self visitSolid: node operand
]
