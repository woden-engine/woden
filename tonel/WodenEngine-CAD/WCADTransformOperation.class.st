Class {
	#name : #WCADTransformOperation,
	#superclass : #WCADOperation,
	#instVars : [
		'operand'
	],
	#category : #'WodenEngine-CAD-CSG'
}

{ #category : #accessing }
WCADTransformOperation >> children [
	^ { operand }
]

{ #category : #testing }
WCADTransformOperation >> isTransformOperation [
	^ true
]

{ #category : #accessing }
WCADTransformOperation >> operand [

	^ operand
]

{ #category : #accessing }
WCADTransformOperation >> operand: anObject [

	operand := anObject
]
