factory
createSampleFor: sample
	| sid |
	self asCurrentDo: [
		sid := OpenAL genBuffer.
	].

	^ WTOpenALSoundSample new device: self; handle: sid; uploadSample: sample