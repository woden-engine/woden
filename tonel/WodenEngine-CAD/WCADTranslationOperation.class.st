Class {
	#name : #WCADTranslationOperation,
	#superclass : #WCADTransformOperation,
	#instVars : [
		'translation'
	],
	#category : #'WodenEngine-CAD-CSG'
}

{ #category : #visiting }
WCADTranslationOperation >> accept: visitor [
	^ visitor visitTranslationOperation: self
]

{ #category : #accessing }
WCADTranslationOperation >> boundingBox [
	^ operand boundingBox translatedBy: translation
]

{ #category : #initialization }
WCADTranslationOperation >> initialize [
	super initialize.
	translation := Float64x3 zeros.
]

{ #category : #transformations }
WCADTranslationOperation >> translatedBy: extraTranslation [
	^ self copy translation: translation + extraTranslation
]

{ #category : #accessing }
WCADTranslationOperation >> translation [

	^ translation
]

{ #category : #accessing }
WCADTranslationOperation >> translation: anObject [

	translation := anObject implicitCastTo: Float64x3
]
