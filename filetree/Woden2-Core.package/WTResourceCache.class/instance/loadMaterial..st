resource loading
loadMaterial: aFileNameOrReference
	| materialFile |
	materialFile := self resolveResourceFileReference: aFileNameOrReference.
	^ resources at: materialFile -> #material ifAbsentPut: [ self performMaterialLoading: materialFile ].
