materials
loadMaterial: aFileNameOrReference
	| materialFile |
	materialFile := self resolveResourceFileReference: aFileNameOrReference.
	^ self resourceAt: materialFile -> #material ifAbsentPut: [ self performMaterialLoading: materialFile ].
