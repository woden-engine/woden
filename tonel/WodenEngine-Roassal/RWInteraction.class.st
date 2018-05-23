Class {
	#name : #RWInteraction,
	#superclass : #RWObject,
	#category : #'WodenEngine-Roassal-Interaction'
}

{ #category : #public }
RWInteraction class >> initializeElement: element [
	^ self new initializeElement: element; yourself
]
