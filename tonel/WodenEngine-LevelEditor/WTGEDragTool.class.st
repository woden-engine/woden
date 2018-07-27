Class {
	#name : #WTGEDragTool,
	#superclass : #WTGEToolController,
	#category : #'WodenEngine-LevelEditor-Old'
}

{ #category : #'as yet unclassified' }
WTGEDragTool >> needsMouseCapture [
	^ true
]

{ #category : #events }
WTGEDragTool >> onDragEndEvent: anEvent [
	view toolControllerFinished
]
