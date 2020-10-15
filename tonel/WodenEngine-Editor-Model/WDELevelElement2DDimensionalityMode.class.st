Class {
	#name : #WDELevelElement2DDimensionalityMode,
	#superclass : #WDELevelElementDimensionalityMode,
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #testing }
WDELevelElement2DDimensionalityMode >> is2D [
	^ true
]

{ #category : #'as yet unclassified' }
WDELevelElement2DDimensionalityMode >> sanitizePosition: aPosition [
	^ Float32x3 xy: aPosition xy z: 0.0
]
