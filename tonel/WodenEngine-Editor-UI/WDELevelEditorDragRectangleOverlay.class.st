Class {
	#name : #WDELevelEditorDragRectangleOverlay,
	#superclass : #WDELevelEditorScreenOverlay,
	#instVars : [
		'rectangle',
		'color'
	],
	#category : #'WodenEngine-Editor-UI-Overlays'
}

{ #category : #rendering }
WDELevelEditorDragRectangleOverlay >> buildUISceneGraphWith: builder [
	^ builder borderRectangle: rectangle color: color width: 1
]

{ #category : #accessing }
WDELevelEditorDragRectangleOverlay >> color [
	^ color
]

{ #category : #accessing }
WDELevelEditorDragRectangleOverlay >> color: anObject [
	color := anObject
]

{ #category : #accessing }
WDELevelEditorDragRectangleOverlay >> rectangle [
	^ rectangle
]

{ #category : #accessing }
WDELevelEditorDragRectangleOverlay >> rectangle: anObject [
	rectangle := anObject
]
