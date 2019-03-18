Class {
	#name : #WDCAbstractProceduralMap,
	#superclass : #Object,
	#category : #'WodenEngine-Core-Texture'
}

{ #category : #converting }
WDCAbstractProceduralMap >> asDastrelColorMapFunction [
	self subclassResponsibility
]

{ #category : #testing }
WDCAbstractProceduralMap >> isGrayscaleColorMap [
	^ false
]
