Class {
	#name : #WDELevelElement2DDimensionalityMode,
	#superclass : #WDELevelElementDimensionalityMode,
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #accessing }
WDELevelElement2DDimensionalityMode >> dimensionalityMode [
	^ '2D'
]

{ #category : #testing }
WDELevelElement2DDimensionalityMode >> is2D [
	^ true
]

{ #category : #accessing }
WDELevelElement2DDimensionalityMode >> name [
	^ '2D'
]

{ #category : #'as yet unclassified' }
WDELevelElement2DDimensionalityMode >> sanitizePosition: aPosition [
	^ Float32x3 xy: aPosition xy z: 0.0
]
