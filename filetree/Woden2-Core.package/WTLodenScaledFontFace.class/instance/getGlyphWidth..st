accessing
getGlyphWidth: aCharacter
	^ (originalFace getGlyphWidth: aCharacter) * self scaleFactor