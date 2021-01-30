Class {
	#name : #WDADoubleClickEvent,
	#superclass : #OSMouseButtonEvent,
	#category : #'WodenEngine-Core-Application-Events'
}

{ #category : #visitor }
WDADoubleClickEvent >> accept: aVisitor [
	^ aVisitor visitDoubleClickEvent: self
]
