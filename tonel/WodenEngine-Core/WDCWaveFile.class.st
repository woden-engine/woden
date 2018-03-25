Class {
	#name : #WDCWaveFile,
	#superclass : #Object,
	#instVars : [
		'header',
		'format',
		'samples'
	],
	#classVars : [
		'DataChunkSignature',
		'FormatChunkSignature',
		'FormatIEEEFloat',
		'FormatPCM',
		'WaveHeaderSignature',
		'WaveIDValue'
	],
	#category : 'WodenEngine-Core-Sound'
}

{ #category : #'as yet unclassified' }
WDCWaveFile class >> fourCC: aString [
	self assert: aString size = 4.
	^ aString asByteArray unsignedLongAt: 1 bigEndian: false
]

{ #category : #'as yet unclassified' }
WDCWaveFile class >> initialize [
	super initialize.
	
	WaveHeaderSignature := self fourCC: 'RIFF'.
	WaveIDValue := self fourCC: 'WAVE'.
	FormatChunkSignature := self fourCC: 'fmt '.
	DataChunkSignature := self fourCC: 'data'.
	
	FormatPCM := 16r1.
	FormatIEEEFloat := 16r6.
]

{ #category : #loading }
WDCWaveFile class >> loadFromFileNamed: fileName [
	^ self new loadFromFileNamed: fileName
]

{ #category : #'as yet unclassified' }
WDCWaveFile >> asSoundSampleFor: engine [
	| soundSample |
	soundSample := engine createSoundSample.
	soundSample
		format: (format bitsPerSample = 8 ifTrue: [#byte] ifFalse: [#short]);
		sampleRate: format samplersPerSecond;
		channels: format channels;
		data: samples.
	^ soundSample.
]

{ #category : #private }
WDCWaveFile >> loadFrom: in [
	| sampleChunkHeader formatHeader formatData |
	header := WTWaveHeader newFrom: (in next: WTWaveHeader structureSize).
	header signature ~= WaveHeaderSignature ifTrue: [ 
		self error: 'Wave file contains an invalid signature.'
	].
	header waveID ~= WaveIDValue ifTrue: [ 
		self error: 'Wave file contains an invalid WAVE id signature.'
	].

	formatHeader := WTWaveChunkHeader newFrom: (in next: WTWaveChunkHeader structureSize).
	formatHeader chunkID ~= FormatChunkSignature ifTrue: [ 
		self error: 'Wave file contains an invalid format chunk.'
	].

	format := WTWaveFormatChunk new.
	formatData := in next: formatHeader chunkSize.
	format readBytesFrom: formatData size: formatData size position: 1.
	self assert: (format formatTag = FormatPCM or: [format formatTag = FormatIEEEFloat]).
	self assert: (#(8 16 32) includes: format bitsPerSample).

	sampleChunkHeader := WTWaveChunkHeader newFrom: (in next: WTWaveChunkHeader structureSize).
	sampleChunkHeader chunkID ~= DataChunkSignature ifTrue: [ 
		self error: 'Wave file contains an invalid data chunk.'
	].
	samples := in next: sampleChunkHeader chunkSize
	
]

{ #category : #loading }
WDCWaveFile >> loadFromFileNamed: fileName [
	fileName asFileReference readStreamDo: [ :in |
		in binary.
		self loadFrom: in
	]
	
]
