Class {
	#name : #WDELevelEditorSelectionClickWheel,
	#superclass : #Object,
	#instVars : [
		'clickPosition',
		'elements',
		'index'
	],
	#classVars : [
		'PositionValidationTolerance'
	],
	#category : #'WodenEngine-Editor-UI-ViewMode'
}

{ #category : #'class initialization' }
WDELevelEditorSelectionClickWheel class >> initialize [
	PositionValidationTolerance := 10.
]

{ #category : #private }
WDELevelEditorSelectionClickWheel >> advance [
	elements ifEmpty: [ ^ self ].
	index := index + 1.
	index > (elements size + 1) ifTrue: [
		index := 1.
	]
]

{ #category : #accessing }
WDELevelEditorSelectionClickWheel >> clickPosition [

	^ clickPosition
]

{ #category : #accessing }
WDELevelEditorSelectionClickWheel >> clickPosition: anObject [

	clickPosition := anObject
]

{ #category : #private }
WDELevelEditorSelectionClickWheel >> currentElement [
	elements ifNil: [ ^ nil  ].
	index <= elements size ifTrue: [ ^ elements at: index ].
	^ nil
]

{ #category : #accessing }
WDELevelEditorSelectionClickWheel >> elements [

	^ elements
]

{ #category : #accessing }
WDELevelEditorSelectionClickWheel >> elements: anObject [

	elements := anObject
]

{ #category : #accessing }
WDELevelEditorSelectionClickWheel >> index [

	^ index
]

{ #category : #initialization }
WDELevelEditorSelectionClickWheel >> initialize [
	index := 1
]

{ #category : #testing }
WDELevelEditorSelectionClickWheel >> isValidForPosition: testPosition [
	^ (clickPosition - testPosition) asFloat32x2 length2 < (PositionValidationTolerance*PositionValidationTolerance)
]

{ #category : #testing }
WDELevelEditorSelectionClickWheel >> isValidForPositionForRightClick: testPosition [
	^ self isValidForPosition: testPosition

]

{ #category : #testing }
WDELevelEditorSelectionClickWheel >> isValidForPositionForRightClick: testPosition view: aView [
	| testElement ray |
	testElement := self currentElement.
	testElement ifNil: [ ^ false ].
	(self isValidForPosition: testPosition) ifTrue: [ ^ true ].
	
	ray := aView rayForScreenPosition: testPosition.
	^ (testElement rayCast: ray) isNotNil

]
