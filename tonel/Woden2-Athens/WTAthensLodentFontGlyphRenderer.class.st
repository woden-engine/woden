Class {
	#name : #WTAthensLodentFontGlyphRenderer,
	#superclass : #Object,
	#instVars : [
		'surface',
		'font'
	],
	#category : 'Woden2-Athens'
}

{ #category : #accessing }
WTAthensLodentFontGlyphRenderer >> font [
	^ font
]

{ #category : #accessing }
WTAthensLodentFontGlyphRenderer >> font: anObject [
	font := anObject
]

{ #category : #rendering }
WTAthensLodentFontGlyphRenderer >> renderCharacters: aString from: start to: end [
	surface renderLodenFont: font characters: aString from: start to: end. 

]

{ #category : #accessing }
WTAthensLodentFontGlyphRenderer >> surface [
	^ surface
]

{ #category : #accessing }
WTAthensLodentFontGlyphRenderer >> surface: anObject [
	surface := anObject
]
