initialization
createFontManager
	fontManager ifNil: [
		fontManager := WTFontManager new.
		fontManager initializeForEngine: self.
 	].

	fontManager sessionChanged