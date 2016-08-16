as yet unclassified
loadLodenFontFaceMetadataNamed: faceName fromFile: fileReference
	| header glyphMetaData charMapData fontFace characterMap |
	fontFace := WTLodenFontFace new.
	fontFace name: faceName.
	fileReference readStreamDo: [ :in |
		in binary.
		(in next: 8) = LodenFontSignature ifFalse: [ ^ nil ]. 
		header := WTLodenFontHeader newFrom: (in next: WTLodenFontHeader structureSize).
		fontFace
			cellMargin: header cellMargin;
			flags: header flags;
			basePointSize: header pointSize.
			
		glyphMetaData := NativeOrderedCollection for: WTLodenFontGlyphMetadata.
		glyphMetaData useDataFromByteArray: (in next: header numberOfGlyphs * WTLodenFontGlyphMetadata structureSize).
		fontFace glyphs: glyphMetaData asArray.
		
		charMapData := NativeOrderedCollection for: WTLodenFontCharMapEntry.
		charMapData useDataFromByteArray: (in next: header numberOfCharMapEntries * WTLodenFontCharMapEntry structureSize).
		characterMap := Dictionary new.
		fontFace characterMap: characterMap.
		charMapData do: [ :char |
			characterMap at: char character asCharacter put: char glyph.
		].
	].

	fontFace sdfFont: (fontFace flags anyMask: LdfSignedDistanceField).
	fontFace computeGlobalFontMetrics.
	^ fontFace