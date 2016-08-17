resource loading
loadSRGBTexture: aFileNameOrReference
	| textureFile |
	textureFile := self resolveResourceFileReference: aFileNameOrReference.
	^ self resourceAt: textureFile -> #srgbTexture ifAbsentPut: [ (self loadTextureData: textureFile) asSRGBTextureFor: engine ].

	