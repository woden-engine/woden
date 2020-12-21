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
RWPopupOverlay >> buildUISceneGraphWith: builder [
	^ builder withTranslation: position build: [ 
		drawingBlock cull: builder cull: self
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
