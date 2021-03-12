Class {
	#name : #RWCityElementBuilder,
	#superclass : #RWObject,
	#instVars : [
		'interactions'
	],
	#category : #'WodenEngine-Roassal-Builder-CityBuilder'
}

{ #category : #accessing }
RWCityElementBuilder >> addInteraction: anInteraction [
	interactions add: anInteraction
]

{ #category : #interactions }
RWCityElementBuilder >> highlightable [
	self addInteraction: RWHighlightable
]

{ #category : #initialization }
RWCityElementBuilder >> initialize [
	super initialize.
	interactions := OrderedCollection new.
]

{ #category : #interactions }
RWCityElementBuilder >> inspectable [
	self addInteraction: RWTransmissionActivable
]

{ #category : #interactions }
RWCityElementBuilder >> popup [
	self addInteraction: RWPopup
]

{ #category : #interactions }
RWCityElementBuilder >> popup: aPopupText [
	self addInteraction: (RWPopup new text: aPopupText)
]

{ #category : #interactions }
RWCityElementBuilder >> tooltip [
	self addInteraction: RWPopup
]

{ #category : #interactions }
RWCityElementBuilder >> tooltip: aPopupText [
	self addInteraction: (RWPopup new text: aPopupText)
]
