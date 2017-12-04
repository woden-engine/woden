accessing
shootSoundsFor: anEngine
	shootSounds ifNil: [
		shootSounds := self shootSoundNames collect: [:name | anEngine resourceCache loadSoundSample: name ]
	].
	^ shootSounds