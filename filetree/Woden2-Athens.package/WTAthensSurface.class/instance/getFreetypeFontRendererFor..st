as yet unclassified
getFreetypeFontRendererFor: aFreeTypeFont
	self flag: 'Implement this properly.'.
	
	^ WTAthensLodentFontGlyphRenderer new
		font: (engine fontCache default default pointSize: aFreeTypeFont pointSize);
		surface: self;
		yourself