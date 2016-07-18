resource loading
loadMaterial: aFileNameOrReference fallback: aBlock
	| materialFile |
	materialFile := self resolveResourceFileReference: aFileNameOrReference ifFailed: [ ^ aBlock value ].
	^ resources at: materialFile -> #material ifAbsentPut: [ self performMaterialLoading: materialFile ].
