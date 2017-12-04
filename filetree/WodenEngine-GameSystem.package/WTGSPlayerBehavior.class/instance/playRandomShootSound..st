as yet unclassified
playRandomShootSound: sounds
	(sounds isNil or: [ sounds isEmpty ]) ifTrue: [ ^ self ].
	self playShootSound: sounds atRandom