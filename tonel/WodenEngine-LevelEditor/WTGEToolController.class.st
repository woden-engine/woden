Class {
	#name : #WTGEToolController,
	#superclass : #Object,
	#instVars : [
		'view'
	],
	#category : #'WodenEngine-LevelEditor-Old'
}

{ #category : #accessing }
WTGEToolController >> editor [
	^ view editor
]

{ #category : #accessing }
WTGEToolController >> engine [
	^ view engine
]

{ #category : #events }
WTGEToolController >> onDragEndEvent: event [
]

{ #category : #events }
WTGEToolController >> onDragEvent: event [
]

{ #category : #events }
WTGEToolController >> onDragStartEvent: event [
]

{ #category : #events }
WTGEToolController >> onKeyDownEvent: event [
]

{ #category : #events }
WTGEToolController >> onKeyUpEvent: event [
]

{ #category : #utiltity }
WTGEToolController >> roundFloor: value quantum: quantum [
	^ view roundFloor: value quantum: quantum
]

{ #category : #utiltity }
WTGEToolController >> roundToGrid: value [
	^ view roundToGrid: value
]

{ #category : #accessing }
WTGEToolController >> scene [
	^ view scene
]

{ #category : #accessing }
WTGEToolController >> view [
	^ view
]

{ #category : #accessing }
WTGEToolController >> view: anObject [
	view := anObject
]
