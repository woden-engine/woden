3d models
perform3DModelLoading: modelFileReference
	| extension |
	extension := modelFileReference extension.
	extension = 'fmdl' ifTrue: [ ^ FLMaterializer materializeFromByteArray: (self binaryContentsOf: modelFileReference) ].
	extension = 'wmjson' ifTrue: [ ^ WTModelImporter new importFromFileNamed: modelFileReference ].
	self error: 'Unsupported model format.'