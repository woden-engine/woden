resource loading
loadTexture: aFileNameOrReference
	| textureFile |
	textureFile := self resolveResourceFileReference: aFileNameOrReference.
	^ resources at: textureFile -> #srgbTexture ifAbsentPut: [ (self loadTextureData: textureFile) asTextureFor: engine ].
