Class {
	#name : #RWPopupOverlay,
	#superclass : #RWOverlay,
	#instVars : [
		'position',
		'drawingBlock'
	],
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #rendering }
RWPopupOverlay >> drawOnBabylonCanvas: canvas [
	canvas transform restoreAfter: [
		canvas transform translateBy: position.
		drawingBlock cull: canvas
	]

]

{ #category : #accessing }
RWPopupOverlay >> drawingBlock [
	^ drawingBlock
]

{ #category : #accessing }
RWPopupOverlay >> drawingBlock: anObject [
	drawingBlock := anObject
]

{ #category : #accessing }
RWPopupOverlay >> position [
	^ position
]

{ #category : #accessing }
RWPopupOverlay >> position: anObject [
	position := anObject
]
