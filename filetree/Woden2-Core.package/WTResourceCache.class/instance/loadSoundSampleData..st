resource loading
loadSoundSampleData: aFileNameOrReference
	| sampleDataFile |
	sampleDataFile := self resolveResourceFileReference: aFileNameOrReference.
	^ self resourceAt: sampleDataFile -> #soundSampleData ifAbsentPut: [ WTWaveFile loadFromFileNamed: sampleDataFile ].

	