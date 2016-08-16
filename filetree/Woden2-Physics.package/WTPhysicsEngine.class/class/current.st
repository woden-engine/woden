accessing
current
	self checkAndLoadEngine.
	CurrentEngine ifNil: [ self error: 'Not supported physics engine found.' ].
	^ CurrentEngine