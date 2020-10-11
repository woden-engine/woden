Class {
	#name : #WDELevelEditorDragRectangleOverlay,
	#superclass : #WDELevelEditorScreenOverlay,
	#instVars : [
		'rectangle',
		'color'
	],
	#category : #'WodenEngine-Editor-UI-Overlays'
}

{ #category : #accessing }
WDELevelEditorDragRectangleOverlay >> color [
	^ color
]

{ #category : #accessing }
WDELevelEditorDragRectangleOverlay >> color: anObject [
	color := anObject
]

{ #category : #rendering }
WDELevelEditorDragRectangleOverlay >> drawOnBabylonCanvas: canvas [
	| builder |
	builder := canvas driver mesh2DBuilder.
	builder stroke
		color: color;
		width: 1;
		rectangle: rectangle.
	canvas draw: builder mesh
]

{ #category : #accessing }
WDELevelEditorDragRectangleOverlay >> rectangle [
	^ rectangle
]

{ #category : #accessing }
WDELevelEditorDragRectangleOverlay >> rectangle: anObject [
	rectangle := anObject
]
