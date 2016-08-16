as yet unclassified
loadLodenFontFaceNamed: faceName fromFile: fileReference
	| fontFace textureImageName textureImage textureFormat shaderSignature textureBinding texture |
	fontFace := self loadLodenFontFaceMetadataNamed: faceName fromFile: fileReference.
	shaderSignature := engine pipelineStateCache shaderSignatureNamed: #GUI.
	textureImageName := (fileReference fullPath withExtension: 'png') asFileReference.
	textureImage := PNGReadWriter formFromFileNamed: textureImageName.

	textureFormat := fontFace sdfFont ifTrue: [ AGPU_TEXTURE_FORMAT_R8_SNORM ] ifFalse: [ AGPU_TEXTURE_FORMAT_R8_UNORM ].
	texture := engine createTextureFromForm: textureImage format: textureFormat.
	textureBinding := engine createShaderSignature: shaderSignature resourceBinding: 2.
	textureBinding bindTexture: 0 texture: texture startMiplevel: 0 miplevels: -1 lodclamp: 0.0.
	
	fontFace
		textureExtent: textureImage extent;
		texture: textureBinding.
	^ fontFace