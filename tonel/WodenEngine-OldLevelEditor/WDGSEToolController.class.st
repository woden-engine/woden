Class {
	#name : #WDGSEToolController,
	#superclass : #Object,
	#instVars : [
		'view'
	],
	#category : #'WodenEngine-OldLevelEditor-Tools'
}

{ #category : #accessing }
WDGSEToolController >> editor [
	^ view editor
]

{ #category : #accessing }
WDGSEToolController >> engine [
	^ view engine
]

{ #category : #events }
WDGSEToolController >> onDragEndEvent: event [
]

{ #category : #events }
WDGSEToolController >> onDragEvent: event [
]

{ #category : #events }
WDGSEToolController >> onDragStartEvent: event [
]

{ #category : #events }
WDGSEToolController >> onKeyDownEvent: event [
]

{ #category : #events }
WDGSEToolController >> onKeyUpEvent: event [
]

{ #category : #utiltity }
WDGSEToolController >> roundFloor: value quantum: quantum [
	^ view roundFloor: value quantum: quantum
]

{ #category : #utiltity }
WDGSEToolController >> roundToGrid: value [
	^ view roundToGrid: value
]

{ #category : #accessing }
WDGSEToolController >> scene [
	^ view scene
]

{ #category : #accessing }
WDGSEToolController >> view [
	^ view
]

{ #category : #accessing }
WDGSEToolController >> view: anObject [
	view := anObject
]
