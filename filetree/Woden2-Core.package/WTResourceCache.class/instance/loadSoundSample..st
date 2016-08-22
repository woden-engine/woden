resource loading
loadSoundSample: aFileNameOrReference
	| sampleFile |
	sampleFile := self resolveResourceFileReference: aFileNameOrReference.
	^ self resourceAt: sampleFile -> #soundSample ifAbsentPut: [ (self loadSoundSampleData: aFileNameOrReference) asSoundSampleFor: engine ].

	