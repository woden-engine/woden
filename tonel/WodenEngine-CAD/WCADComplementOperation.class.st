Class {
	#name : #WCADComplementOperation,
	#superclass : #WCADOperation,
	#instVars : [
		'operand'
	],
	#category : #'WodenEngine-CAD-CSG'
}

{ #category : #visiting }
WCADComplementOperation >> accept: visitor [
	^ visitor visitComplementOperation: self
]

{ #category : #accessing }
WCADComplementOperation >> boundingBox [
	^ BoxF64 fullSpace
]

{ #category : #boolean }
WCADComplementOperation >> complement [
	^ operand
]

{ #category : #testing }
WCADComplementOperation >> isComplementOperation [
	^ false
]

{ #category : #accessing }
WCADComplementOperation >> operand [

	^ operand
]

{ #category : #accessing }
WCADComplementOperation >> operand: anObject [

	operand := anObject
]
