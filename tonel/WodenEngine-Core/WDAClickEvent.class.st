Class {
	#name : #WDAClickEvent,
	#superclass : #OSMouseButtonEvent,
	#category : #'WodenEngine-Core-Application-Events'
}

{ #category : #visitor }
WDAClickEvent >> accept: aVisitor [
	^ aVisitor visitClickEvent: self
]
