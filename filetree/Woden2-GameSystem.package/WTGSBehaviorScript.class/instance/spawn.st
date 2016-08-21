map events
spawn
	spawnMethod ifNil: [ ^ self ].
	spawnMethod valueWithReceiver: self arguments: #()
