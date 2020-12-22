Class {
	#name : #WCADSolidVisitor,
	#superclass : #Object,
	#category : #'WodenEngine-CAD-CSG'
}

{ #category : #visiting }
WCADSolidVisitor >> visitBasicSolid: basicSolid [
	^ self subclassResponsibility
]

{ #category : #visiting }
WCADSolidVisitor >> visitBooleanOperation: operation [
	^ self visitOperation: operation
]

{ #category : #visiting }
WCADSolidVisitor >> visitBox: box [
	^ self visitBasicSolid: box
]

{ #category : #visiting }
WCADSolidVisitor >> visitDifferenceOperation: operation [
	^ self visitBooleanOperation: operation
]

{ #category : #visiting }
WCADSolidVisitor >> visitEllipsoid: ellipsoid [
	^ self visitBasicSolid: ellipsoid
]

{ #category : #visiting }
WCADSolidVisitor >> visitIntersectionOperation: operation [
	^ self visitBooleanOperation: operation
]

{ #category : #visiting }
WCADSolidVisitor >> visitOperation: operation [
	^ self subclassResponsibility
]

{ #category : #visiting }
WCADSolidVisitor >> visitRotationOperation: operation [
	^ self visitTransformOperation: operation
]

{ #category : #visiting }
WCADSolidVisitor >> visitScaleOperation: operation [
	^ self visitTransformOperation: operation
]

{ #category : #visiting }
WCADSolidVisitor >> visitSolid: solid [
	^ solid accept: self
]

{ #category : #visiting }
WCADSolidVisitor >> visitSphere: sphere [
	^ self visitBasicSolid: sphere
]

{ #category : #visiting }
WCADSolidVisitor >> visitTransformOperation: operation [
	^ self visitOperation: operation
]

{ #category : #visiting }
WCADSolidVisitor >> visitTranslationOperation: operation [
	^ self visitTransformOperation: operation
]

{ #category : #visiting }
WCADSolidVisitor >> visitUnionOperation: operation [
	^ self visitBooleanOperation: operation
]
