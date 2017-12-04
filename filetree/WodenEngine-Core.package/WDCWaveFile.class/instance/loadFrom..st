private
loadFrom: in
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
	