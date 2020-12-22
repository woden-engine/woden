Class {
	#name : #WCADBooleanOperation,
	#superclass : #WCADOperation,
	#instVars : [
		'leftOperand',
		'rightOperand'
	],
	#category : #'WodenEngine-CAD-CSG'
}

{ #category : #accessing }
WCADBooleanOperation >> children [
	^ { leftOperand . rightOperand }
]

{ #category : #accessing }
WCADBooleanOperation >> leftOperand [

	^ leftOperand
]

{ #category : #accessing }
WCADBooleanOperation >> leftOperand: anObject [

	leftOperand := anObject
]

{ #category : #accessing }
WCADBooleanOperation >> rightOperand [

	^ rightOperand
]

{ #category : #accessing }
WCADBooleanOperation >> rightOperand: anObject [

	rightOperand := anObject
]
