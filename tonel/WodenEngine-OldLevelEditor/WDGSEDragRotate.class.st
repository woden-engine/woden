Class {
	#name : #WDGSEDragRotate,
	#superclass : #WDGSEDragTool,
	#instVars : [
		'pivotPoint',
		'onNewRotation',
		'startPosition'
	],
	#category : #'WodenEngine-OldLevelEditor-Tools'
}

{ #category : #'as yet unclassified' }
WDGSEDragRotate >> needsMouseCapture [
	^ false
]

{ #category : #'as yet unclassified' }
WDGSEDragRotate >> onDragEvent: event [
	| newPosition u v rotation angle |
	newPosition := view globalPointToLocal: event position.
	
	u := startPosition asWMComplexF - pivotPoint asWMComplexF.
	v := newPosition asWMComplexF - pivotPoint asWMComplexF.
	(v closeTo: [ WMComplexF new ]) ifTrue: [ 
		angle := 0.0.
	] ifFalse: [ 
		rotation := v / u.
		angle := rotation angle.
	].

	onNewRotation value: angle
]

{ #category : #'as yet unclassified' }
WDGSEDragRotate >> onDragStartEvent: event [
	startPosition := view globalPointToLocal: event position.
	
]

{ #category : #accessing }
WDGSEDragRotate >> onNewRotation [
	^ onNewRotation
]

{ #category : #accessing }
WDGSEDragRotate >> onNewRotation: anObject [
	onNewRotation := anObject
]

{ #category : #accessing }
WDGSEDragRotate >> pivotPoint [
	^ pivotPoint
]

{ #category : #accessing }
WDGSEDragRotate >> pivotPoint: anObject [
	pivotPoint := anObject
]
