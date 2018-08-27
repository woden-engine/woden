Class {
	#name : #WDGSEDragTool,
	#superclass : #WDGSEToolController,
	#category : #'WodenEngine-LevelEditor-Tools'
}

{ #category : #'as yet unclassified' }
WDGSEDragTool >> needsMouseCapture [
	^ true
]

{ #category : #events }
WDGSEDragTool >> onDragEndEvent: anEvent [
	view toolControllerFinished
]
