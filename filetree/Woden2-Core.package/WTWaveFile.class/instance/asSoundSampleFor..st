as yet unclassified
asSoundSampleFor: engine
	| soundSample |
	soundSample := engine createSoundSample.
	soundSample
		format: (format bitsPerSample = 8 ifTrue: [#byte] ifFalse: [#short]);
		sampleRate: format samplersPerSecond;
		channels: format channels;
		data: samples.
	^ soundSample.