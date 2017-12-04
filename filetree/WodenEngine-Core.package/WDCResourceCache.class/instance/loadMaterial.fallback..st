materials
loadMaterial: aFileNameOrReference fallback: aBlock
	| materialFile |
	materialFile := self resolveResourceFileReference: aFileNameOrReference ifFailed: [ ^ aBlock value ].
	^ self resourceAt: materialFile -> #material ifAbsentPut: [ self performMaterialLoading: materialFile ].
