Class {
	#name : #WTAthensFontMetricsProvider,
	#superclass : #Object,
	#instVars : [
		'font',
		'actualFont'
	],
	#category : 'Woden2-Athens'
}

{ #category : #accessing }
WTAthensFontMetricsProvider >> font [
	^ font
]

{ #category : #accessing }
WTAthensFontMetricsProvider >> font: aFont [
	font := aFont asFreetypeFont.
	
	"HACK"
	actualFont := WTFontCache defaultFontBlocHack pointSize: aFont pointSize
]

{ #category : #'as yet unclassified' }
WTAthensFontMetricsProvider >> fontAscent [
	^ "font ascent" actualFont getPreciseAscent
]

{ #category : #'as yet unclassified' }
WTAthensFontMetricsProvider >> fontHeight [
	^ "font height" actualFont height
]

{ #category : #'as yet unclassified' }
WTAthensFontMetricsProvider >> getGlyphWidth: aCharacter [
	^ "font getGlyphWidth: aCharacter" actualFont getGlyphWidth: aCharacter
]

{ #category : #'as yet unclassified' }
WTAthensFontMetricsProvider >> newCharacterSpanDisplayCommand: span start: startPos stop: stopPos advance: aPoint [
	^ WTAthensTxCharacterSpanDisplayCommand new 
			span: span start: startPos stop: stopPos;
			advance: aPoint;
			yourself
]
