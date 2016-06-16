initialization
createFontCache
	fontCache ifNil: [
		fontCache := WTFontCache new.
		fontCache initializeForEngine: self.
 	].

	fontCache sessionChanged