Class {
	#name : #WDCGrayscaleColorMap,
	#superclass : #WDCAbstractProceduralMap,
	#category : #'WodenEngine-Core-Texture'
}

{ #category : #accessing }
WDCGrayscaleColorMap >> value: gray [
	^ Color gray: gray
]
