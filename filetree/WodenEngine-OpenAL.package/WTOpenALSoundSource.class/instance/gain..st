accessing
gain: anObject
	gain := anObject.
	
	device asCurrentDo: [
		OpenAL sourcef: handle param: AL_GAIN value: gain.
	]