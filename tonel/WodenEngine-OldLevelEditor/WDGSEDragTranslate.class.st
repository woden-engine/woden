Class {
	#name : #WDGSEDragTranslate,
	#superclass : #WDGSEDragTool,
	#instVars : [
		'depthPoint',
		'onNewTranslation',
		'totalDelta'
	],
	#category : #'WodenEngine-OldLevelEditor-Tools'
}

{ #category : #accessing }
WDGSEDragTranslate >> depthPoint [
	^ depthPoint
]

{ #category : #accessing }
WDGSEDragTranslate >> depthPoint: anObject [
	depthPoint := anObject
]

{ #category : #events }
WDGSEDragTranslate >> initialize [
	super initialize.
	totalDelta := 0@0.
]

{ #category : #events }
WDGSEDragTranslate >> onDragEvent: event [
	| dragDelta depth |
	depth := view depthAtCameraDistance: 3.0.
	totalDelta := totalDelta + event delta.
	dragDelta := (view windowGlobalToWorld: totalDelta depth: depth) - (view windowGlobalToWorld: 0@0 depth: depth).
	onNewTranslation value: dragDelta.
]

{ #category : #accessing }
WDGSEDragTranslate >> onNewTranslation [
	^ onNewTranslation
]

{ #category : #accessing }
WDGSEDragTranslate >> onNewTranslation: anObject [
	onNewTranslation := anObject
]
