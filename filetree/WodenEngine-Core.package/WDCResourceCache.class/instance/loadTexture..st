resource loading
loadTexture: aFileNameOrReference
	| textureFile |
	textureFile := self resolveResourceFileReference: aFileNameOrReference.
	^ self resourceAt: textureFile -> #texture ifAbsentPut: [ (self loadTextureData: textureFile) asTextureFor: engine ].
