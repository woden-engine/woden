Class {
	#name : #WDCStateTrackerSubRenderMode,
	#superclass : #Object,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'WodenEngine-Core-Rendering'
}

{ #category : #'as yet unclassified' }
WDCStateTrackerSubRenderMode class >> flatColor [
	^ WDCStateTrackerFlatColorRenderMode uniqueInstance
]

{ #category : #'as yet unclassified' }
WDCStateTrackerSubRenderMode class >> flatTextured [
	^ WDCStateTrackerFlatTexturedRenderMode uniqueInstance
]

{ #category : #'as yet unclassified' }
WDCStateTrackerSubRenderMode class >> fullShaded [
	^ WDCStateTrackerFullShadedRenderMode uniqueInstance
]

{ #category : #accessing }
WDCStateTrackerSubRenderMode class >> isAbstract [
	^ self == WDCStateTrackerSubRenderMode
]

{ #category : #'as yet unclassified' }
WDCStateTrackerSubRenderMode class >> materialValidation [
	^ WDCStateTrackerMaterialValidationRenderMode uniqueInstance
]

{ #category : #'as yet unclassified' }
WDCStateTrackerSubRenderMode class >> shadedColor [
	^ WDCStateTrackerShadedColorRenderMode uniqueInstance
]

{ #category : #accessing }
WDCStateTrackerSubRenderMode class >> uniqueInstance [
	self assert: self isAbstract not.
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #'as yet unclassified' }
WDCStateTrackerSubRenderMode class >> wireframe [
	^ WDCStateTrackerWireFrameRenderMode uniqueInstance
]

{ #category : #testing }
WDCStateTrackerSubRenderMode >> hasNoTextures [
	^ false
]

{ #category : #testing }
WDCStateTrackerSubRenderMode >> isFlatColor [
	^ false
]

{ #category : #testing }
WDCStateTrackerSubRenderMode >> isFlatTextured [
	^ false
]

{ #category : #testing }
WDCStateTrackerSubRenderMode >> isFullShaded [
	^ false
]

{ #category : #testing }
WDCStateTrackerSubRenderMode >> isMaterialValidation [
	^ false
]

{ #category : #testing }
WDCStateTrackerSubRenderMode >> isShaded [
	^ false
]

{ #category : #testing }
WDCStateTrackerSubRenderMode >> isShadedColor [
	^ false
]

{ #category : #testing }
WDCStateTrackerSubRenderMode >> isWireFrame [
	^ false
]
