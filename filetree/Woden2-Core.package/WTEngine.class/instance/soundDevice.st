accessing
soundDevice
	soundDevice ifNil: [ soundDevice := WTSoundEngine current createSoundDevice].
	^ soundDevice