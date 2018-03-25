"
Define a popup on the element. Here is an example:
-=-=-=-=-=-=
v := RWView new.

c := RWCube element.
v add: c.

c addInteraction: RWPopup.

v open
-=-=-=-=-=-=
"
Class {
	#name : #RWPopup,
	#superclass : #RWElementInteraction,
	#instVars : [
		'text',
		'color'
	],
	#classVars : [
		'LastPopup'
	],
	#category : 'WodenEngine-Roassal-Core'
}

{ #category : #accessing }
RWPopup >> color [
	^ color
]

{ #category : #accessing }
RWPopup >> color: anObject [
	color := anObject
]

{ #category : #initialization }
RWPopup >> defaultPopupColor [
	^ Color red
]

{ #category : #initialization }
RWPopup >> initialize [
	super initialize.
	color := self defaultPopupColor.
	text := #yourself
]

{ #category : #hooks }
RWPopup >> initializeElement: anElement [
	anElement
		when: RWMouseEnter
		do: [ :evt | 
			self removeLastPopupIfNecessary.
			LastPopup := TextMorph new contentsAsIs: (self textFor: anElement).
			LastPopup color: Color red.
			LastPopup position: ActiveHand position.
			LastPopup openInWorld ].
	anElement when: RWMouseLeave do: [ :evt | self removeLastPopupIfNecessary ]
]

{ #category : #utility }
RWPopup >> removeLastPopupIfNecessary [
	^ LastPopup notNil
		ifTrue: [ 
			LastPopup delete.
			LastPopup := nil ]
]

{ #category : #accessing }
RWPopup >> text [
	^ text
]

{ #category : #accessing }
RWPopup >> text: aBlockOrASymbol [
	"Evaluated against the model of the Roassal element"
	text := aBlockOrASymbol
]

{ #category : #utility }
RWPopup >> textFor: element [
	^ (text rwValue: element model) asString
]
