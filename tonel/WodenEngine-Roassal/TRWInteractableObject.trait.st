Trait {
	#name : #TRWInteractableObject,
	#instVars : [
		'interactions'
	],
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #operations }
TRWInteractableObject >> @ anInteraction [

	self addInteraction: anInteraction
]

{ #category : #interaction }
TRWInteractableObject >> addInteraction: anInteraction [
	anInteraction installOnElement: self
]

{ #category : #adding }
TRWInteractableObject >> addInteractions: newInteractions [
	newInteractions do: [ :each | self addInteraction: each ]
]

{ #category : #accessing }
TRWInteractableObject >> interactions [
	^ interactions ifNil: [ interactions := OrderedCollection new ]
]
