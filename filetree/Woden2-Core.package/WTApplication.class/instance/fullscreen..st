accessing
fullscreen: anObject
	window ifNotNil: [ window fullscreen: anObject ].
	fullscreen := anObject.
