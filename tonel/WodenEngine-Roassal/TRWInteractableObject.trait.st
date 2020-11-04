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

{ #category : #accessing }
TRWInteractableObject >> interactions [
	^ interactions ifNil: [ interactions := OrderedCollection new ]
]
