Class {
	#name : #RWPyramid,
	#superclass : #RWCone,
	#category : 'WodenEngine-Roassal-Core'
}

{ #category : #configuration }
RWPyramid class >> defaultSegments [
	^ 2
]

{ #category : #configuration }
RWPyramid class >> defaultSlices [
	^ 4
]

{ #category : #visiting }
RWPyramid >> accept: aVisitor [
	^ aVisitor visitPyramidShape: self
]
