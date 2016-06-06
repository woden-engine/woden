as yet unclassified
computeGlobalFontMetrics
	ascent := 0.
	descent := 0.
	glyphs do: [ :glyph |
		ascent := ascent max: glyph computePreciseAscent.
		descent := descent max: glyph computePreciseDescent.
	].