Class {
	#name : #RWInteraction,
	#superclass : #RWObject,
	#category : #'WodenEngine-Roassal-Interaction'
}

{ #category : #public }
RWInteraction class >> initializeElement: element [
	^ self new initializeElement: element; yourself
]

{ #category : #hooks }
RWInteraction >> registerOn: anElement [
	"Register the interaction in the attribute field of the element"
	anElement attributeAt: self class name asSymbol put: self.
]
