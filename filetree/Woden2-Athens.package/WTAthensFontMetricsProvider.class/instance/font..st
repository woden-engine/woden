accessing
font: aFont
	font := aFont asFreetypeFont.
	
	"HACK"
	actualFont := WTFontCache defaultFontBlocHack pointSize: aFont pointSize