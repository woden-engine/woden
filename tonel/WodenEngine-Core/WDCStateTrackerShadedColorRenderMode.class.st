Class {
	#name : #WDCStateTrackerShadedColorRenderMode,
	#superclass : #WDCStateTrackerSubRenderMode,
	#category : #'WodenEngine-Core-Rendering'
}

{ #category : #testing }
WDCStateTrackerShadedColorRenderMode >> hasNoTextures [
	^ true
]

{ #category : #testing }
WDCStateTrackerShadedColorRenderMode >> isColorMode [
	^ true
]

{ #category : #testing }
WDCStateTrackerShadedColorRenderMode >> isShaded [
	^ true
]

{ #category : #testing }
WDCStateTrackerShadedColorRenderMode >> isShadedColor [
	^ true
]
