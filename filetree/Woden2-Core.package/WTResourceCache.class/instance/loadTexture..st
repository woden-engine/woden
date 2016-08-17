resource loading
loadTexture: aFileNameOrReference
	| textureFile |
	textureFile := self resolveResourceFileReference: aFileNameOrReference.
	^ self resourceAt: textureFile -> #srgbTexture ifAbsentPut: [ (self loadTextureData: textureFile) asTextureFor: engine ].
