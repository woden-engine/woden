Class {
	#name : #WTGEDragRotate,
	#superclass : #WTGEDragTool,
	#instVars : [
		'pivotPoint',
		'onNewRotation',
		'startPosition'
	],
	#category : 'Woden2-LevelEditor'
}

{ #category : #'as yet unclassified' }
WTGEDragRotate >> needsMouseCapture [
	^ false
]

{ #category : #'as yet unclassified' }
WTGEDragRotate >> onDragEvent: event [
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
WTGEDragRotate >> onDragStartEvent: event [
	startPosition := view globalPointToLocal: event position.
	
]

{ #category : #accessing }
WTGEDragRotate >> onNewRotation [
	^ onNewRotation
]

{ #category : #accessing }
WTGEDragRotate >> onNewRotation: anObject [
	onNewRotation := anObject
]

{ #category : #accessing }
WTGEDragRotate >> pivotPoint [
	^ pivotPoint
]

{ #category : #accessing }
WTGEDragRotate >> pivotPoint: anObject [
	pivotPoint := anObject
]
