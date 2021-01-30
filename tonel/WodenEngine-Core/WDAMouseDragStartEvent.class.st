Class {
	#name : #WDAMouseDragStartEvent,
	#superclass : #OSMouseButtonEvent,
	#category : #'WodenEngine-Core-Application-Events'
}

{ #category : #visitor }
WDAMouseDragStartEvent >> accept: aVisitor [
	^ aVisitor visitMouseDragStartEvent: self
]
