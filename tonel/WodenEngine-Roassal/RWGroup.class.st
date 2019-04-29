Class {
	#name : #RWGroup,
	#superclass : #OrderedCollection,
	#category : 'WodenEngine-Roassal-Core'
}

{ #category : #converting }
RWGroup >> @ anInteraction [
	^ self addInteraction: anInteraction
]

{ #category : #adding }
RWGroup >> addInteraction: anInteraction [
	^ self do: [ :el | el @ anInteraction  ]
]
