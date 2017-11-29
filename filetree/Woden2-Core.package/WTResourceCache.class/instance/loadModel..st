resource loading
loadModel: aFileNameOrReference
	| modelFile |
	modelFile := self resolveResourceFileReference: aFileNameOrReference.
	^ self resourceAt: modelFile -> #model ifAbsentPut: [ self performModelLoading: modelFile ].
