window handling
fullscreen: aBoolean
	window ifNotNil: [ window fullscreen: aBoolean ].
	fullscreen := aBoolean.
