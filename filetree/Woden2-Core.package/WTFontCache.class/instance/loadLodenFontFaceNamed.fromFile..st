as yet unclassified
loadLodenFontFaceNamed: faceName fromFile: fileReference
	| header glyphMetaData charMapData fontFace characterMap textureImageName textureImage textureFormat shaderSignature textureBinding texture |
	shaderSignature := engine pipelineStateCache shaderSignatureNamed: #GUI.
	textureImageName := (fileReference fullPath withExtension: 'png') asFileReference.
	textureImage := PNGReadWriter formFromFileNamed: textureImageName.
	fontFace := WTLodenFontFace new.
	fontFace name: faceName.
	fileReference readStreamDo: [ :in |
		in binary.
		(in next: 8) = LodenFontSignature ifFalse: [ ^ nil ]. 
		header := WTLodenFontHeader newFrom: (in next: WTLodenFontHeader structureSize).
		fontFace
			cellHeight: header cellHeight;
			cellWidth: header cellWidth;
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
	textureFormat := fontFace sdfFont ifTrue: [ AGPU_TEXTURE_FORMAT_R8_SNORM ] ifFalse: [ AGPU_TEXTURE_FORMAT_R8_UNORM ].
	texture := engine createTextureFromForm: textureImage format: textureFormat.
	textureBinding := engine createShaderSignature: shaderSignature resourceBinding: 2.
	textureBinding bindTexture: 0 texture: texture startMiplevel: 0 miplevels: -1 lodclamp: 0.0.
	
	fontFace
		textureExtent: textureImage extent;
		texture: textureBinding.
	fontFace computeGlobalFontMetrics.
	^ fontFace