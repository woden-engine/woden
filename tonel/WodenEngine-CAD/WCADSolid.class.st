Class {
	#name : #WCADSolid,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'WodenEngine-CAD-CSG'
}

{ #category : #accessing }
WCADSolid class >> box [
	^ WCADBox new
]

{ #category : #accessing }
WCADSolid class >> ellipsoid [
	^ WCADEllipsoid new
]

{ #category : #accessing }
WCADSolid class >> sphere [
	^ WCADSphere new
]

{ #category : #boolean }
WCADSolid >> & other [
	^ self intersection: other
]

{ #category : #boolean }
WCADSolid >> - other [
	^ self difference: other
]

{ #category : #visiting }
WCADSolid >> accept: visitor [
	^ self subclassResponsibility
]

{ #category : #accessing }
WCADSolid >> boundingBox [
	self subclassResponsibility
]

{ #category : #accessing }
WCADSolid >> children [
	^ #()
]

{ #category : #accessing }
WCADSolid >> depth [
	^ self boundingBox depth
]

{ #category : #boolean }
WCADSolid >> difference: other [
	^ WCADDifferenceOperation new leftOperand: self; rightOperand: other; yourself
]

{ #category : #accessing }
WCADSolid >> height [
	^ self boundingBox height
]

{ #category : #boolean }
WCADSolid >> intersection: other [
	^ WCADIntersectionOperation new leftOperand: self; rightOperand: other; yourself
]

{ #category : #testing }
WCADSolid >> isBasicSolid [
	^ false
]

{ #category : #testing }
WCADSolid >> isBooleanOperation [
	^ false
]

{ #category : #testing }
WCADSolid >> isBox [
	^ false
]

{ #category : #testing }
WCADSolid >> isDifferenceOperation [
	^ false
]

{ #category : #testing }
WCADSolid >> isEllipsoid [
	^ false
]

{ #category : #testing }
WCADSolid >> isIntersectionOperation [
	^ false
]

{ #category : #testing }
WCADSolid >> isOperation [
	^ false
]

{ #category : #testing }
WCADSolid >> isSphere [
	^ false
]

{ #category : #testing }
WCADSolid >> isTransformOperation [
	^ false
]

{ #category : #testing }
WCADSolid >> isUnionOperation [
	^ false
]

{ #category : #accessing }
WCADSolid >> name [

	^ name
]

{ #category : #accessing }
WCADSolid >> name: anObject [

	name := anObject
]

{ #category : #transformations }
WCADSolid >> translatedBy: translation [
	^ WCADTranslationOperation new operand: self; translation: translation; yourself
]

{ #category : #transformations }
WCADSolid >> translatedByX: translation [
	^ self translatedBy: (Float64x3 x: translation)
]

{ #category : #transformations }
WCADSolid >> translatedByY: translation [
	^ self translatedBy: (Float64x3 y: translation)
]

{ #category : #transformations }
WCADSolid >> translatedByZ: translation [
	^ self translatedBy: (Float64x3 z: translation)
]

{ #category : #boolean }
WCADSolid >> union: other [
	^ WCADUnionOperation new leftOperand: self; rightOperand: other; yourself
]

{ #category : #accessing }
WCADSolid >> width [
	^ self boundingBox width
]

{ #category : #boolean }
WCADSolid >> | other [
	^ self union: other
]
