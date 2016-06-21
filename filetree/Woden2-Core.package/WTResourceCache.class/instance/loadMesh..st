resource loading
loadMesh: aFileNameOrReference
	| meshFile |
	meshFile := self resolveResourceFileReference: aFileNameOrReference.
	^ resources at: meshFile -> #mesh ifAbsentPut: [ (self loadModel: meshFile) meshFor: engine ].
