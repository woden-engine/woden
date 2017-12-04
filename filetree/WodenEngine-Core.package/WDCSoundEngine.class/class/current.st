accessing
current
	self checkAndLoadEngine.
	CurrentEngine ifNil: [ self error: 'Not supported sound engine found.' ].
	^ CurrentEngine