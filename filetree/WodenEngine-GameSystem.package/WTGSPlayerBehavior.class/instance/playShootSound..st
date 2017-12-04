as yet unclassified
playShootSound: sound
	sound ifNil: [ ^ self ].
	weaponSoundSource dataSource: sound; play