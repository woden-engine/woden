resource loading
loadSRGBTexture: aFileNameOrReference
	| textureFile |
	textureFile := self resolveResourceFileReference: aFileNameOrReference.
	^ resources at: textureFile -> #srgbTexture ifAbsentPut: [ (self loadTextureData: textureFile) asSRGBTextureFor: engine ].

	