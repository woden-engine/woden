resource loading
loadModel: aFileNameOrReference
	| modelFile |
	modelFile := self resolveResourceFileReference: aFileNameOrReference.
	^ resources at: modelFile -> #model ifAbsentPut: [ self performModelLoading: modelFile ].
