as yet unclassified
getGlyphWidth: character
	| glyph |
	glyph := self getGlyph: character.
	glyph ifNil: [ ^ 0 ].
	^ glyph advance x