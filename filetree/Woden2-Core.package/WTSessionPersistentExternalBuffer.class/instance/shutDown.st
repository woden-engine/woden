system startup
shutDown
	pointer ifNil: [ ^ self ].
	data := ByteArray new: size.