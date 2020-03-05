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
RWPopupOverlay >> drawOnScaledBabylonCanvas: canvas [
	canvas transform restoreAfter: [
		canvas transform translateBy: (canvas physicalToLogicalTransformPoint: position).
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
