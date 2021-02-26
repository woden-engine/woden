Class {
	#name : #RWInteraction,
	#superclass : #RWObject,
	#category : #'WodenEngine-Roassal-Interaction'
}

{ #category : #hooks }
RWInteraction class >> installOnElement: element [
	^ self new installOnElement: element; yourself
]

{ #category : #visiting }
RWInteraction >> accept: aVisitor [
	self subclassResponsibility
]

{ #category : #initialization }
RWInteraction >> initializeElement: element [
	self subclassResponsibility
]

{ #category : #hooks }
RWInteraction >> installOnElement: anElement [
	self
		initializeElement: anElement;
		registerOn: anElement
]

{ #category : #hooks }
RWInteraction >> registerOn: anElement [
	"Register the interaction in the attribute field of the element"
	anElement interactions add: self
]
