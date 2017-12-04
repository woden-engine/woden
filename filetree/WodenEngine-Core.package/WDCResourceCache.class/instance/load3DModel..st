3d models
load3DModel: aFileNameOrReference
	| modelFile |
	modelFile := self resolveResourceFileReference: aFileNameOrReference.
	^ self resourceAt: modelFile -> #model ifAbsentPut: [ self perform3DModelLoading: modelFile ].
