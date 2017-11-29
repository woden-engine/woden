resource loading
loadMesh: aFileNameOrReference
	| meshFile |
	meshFile := self resolveResourceFileReference: aFileNameOrReference.
	^ self resourceAt: meshFile -> #mesh ifAbsentPut: [ (self loadModel: meshFile) meshFor: engine ].
