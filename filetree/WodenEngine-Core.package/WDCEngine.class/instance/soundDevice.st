accessing
soundDevice
	soundDevice ifNil: [ soundDevice := WDCSoundEngine current createSoundDevice].
	^ soundDevice