Class {
	#name : #WCADRotationOperation,
	#superclass : #WCADTransformOperation,
	#instVars : [
		'rotation'
	],
	#category : #'WodenEngine-CAD-CSG'
}

{ #category : #visiting }
WCADRotationOperation >> accept: visitor [
	^ visitor visitRotationOperation: self
]
