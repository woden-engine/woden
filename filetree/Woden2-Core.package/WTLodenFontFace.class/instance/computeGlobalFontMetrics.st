as yet unclassified
computeGlobalFontMetrics
	ascent := 0.
	descent := 0.
	height := 0.
	glyphs do: [ :glyph |
		ascent := ascent max: glyph computePreciseAscent.
		descent := descent max: glyph computePreciseDescent.
		height := height max: glyph height
	].

	"TODO: Do this properly"
	height := (height * 0.8) ceiling