as yet unclassified
getGlyph: character
	^ glyphs at: (characterMap at: character ifAbsent: [ ^ nil ])