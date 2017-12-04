factory
createSource
	| sid |
	self asCurrentDo: [
		sid := OpenAL genSource.
	].

	^ WTOpenALSoundSource new device: self; handle: sid