"
I am a model loader that uses fuel for loading models.
"
Class {
	#name : #WDCFuelModelLoader,
	#superclass : #WDCSimpleModelLoader,
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Asset'
}

{ #category : #accessing }
WDCFuelModelLoader class >> extension [
	^ 'fmdl'
]

{ #category : #loading }
WDCFuelModelLoader >> loadFromFileReference: fileReference [
	| materializer |
	materializer := FLMaterializer newDefault
		migrateClassNamed: #WDCModel toClass: WDCSimpleModel;
		migrateClassNamed: #WDCModelArmature toClass: WDCSimpleModelArmature;
		migrateClassNamed: #WDCSeparatedVertexData toClass: WDCMeshImplicitSeparatedVertexData;
		migrateClassNamed: #WDCMeshVertexChannel toClass: WDCMeshImplicitVertexChannel.
	^ fileReference binaryReadStreamDo: [ :in |
		(materializer materializeFrom: in) root
	]
]
