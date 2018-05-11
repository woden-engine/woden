Class {
	#name : #RWDirectLayoutTranslator,
	#superclass : #RWLayoutTranslator,
	#category : #'WodenEngine-Roassal-Layout'
}

{ #category : #hook }
RWDirectLayoutTranslator >> translate: element to: newPosition [
	element translateTo: newPosition
]
