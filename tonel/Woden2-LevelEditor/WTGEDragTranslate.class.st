Class {
	#name : #WTGEDragTranslate,
	#superclass : #WTGEDragTool,
	#instVars : [
		'depthPoint',
		'onNewTranslation',
		'totalDelta'
	],
	#category : 'Woden2-LevelEditor'
}

{ #category : #accessing }
WTGEDragTranslate >> depthPoint [
	^ depthPoint
]

{ #category : #accessing }
WTGEDragTranslate >> depthPoint: anObject [
	depthPoint := anObject
]

{ #category : #events }
WTGEDragTranslate >> initialize [
	super initialize.
	totalDelta := 0@0.
]

{ #category : #events }
WTGEDragTranslate >> onDragEvent: event [
	| dragDelta depth |
	depth := view depthAtCameraDistance: 3.0.
	totalDelta := totalDelta + event delta.
	dragDelta := (view windowGlobalToWorld: totalDelta depth: depth) - (view windowGlobalToWorld: 0@0 depth: depth).
	onNewTranslation value: dragDelta.
]

{ #category : #accessing }
WTGEDragTranslate >> onNewTranslation [
	^ onNewTranslation
]

{ #category : #accessing }
WTGEDragTranslate >> onNewTranslation: anObject [
	onNewTranslation := anObject
]
