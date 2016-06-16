resource loading
loadTextureData: aFileNameOrReference
	| textureFile extension |
	textureFile := self resolveResourceFileReference: aFileNameOrReference.
	extension := textureFile extension.
	extension = 'dds' ifTrue: [ ^ WTDDSTextureReader textureFromFileNamed: textureFile].
	^ ImageReadWriter formFromFileNamed: textureFile