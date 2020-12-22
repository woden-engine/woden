Class {
	#name : #WCADScaleOperation,
	#superclass : #WCADTransformOperation,
	#instVars : [
		'scale'
	],
	#category : #'WodenEngine-CAD-CSG'
}

{ #category : #visiting }
WCADScaleOperation >> accept: visitor [
	^ visitor visitScaleOperation: self
]
