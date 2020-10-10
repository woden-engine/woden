Class {
	#name : #WDCStateTrackerFlatColorRenderMode,
	#superclass : #WDCStateTrackerSubRenderMode,
	#category : #'WodenEngine-Core-Rendering'
}

{ #category : #testing }
WDCStateTrackerFlatColorRenderMode >> hasNoTextures [
	^ true
]

{ #category : #testing }
WDCStateTrackerFlatColorRenderMode >> isFlatColor [
	^ true
]
