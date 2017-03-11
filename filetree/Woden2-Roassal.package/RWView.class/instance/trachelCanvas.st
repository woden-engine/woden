accessing
trachelCanvas
	^ trachelCanvas ifNil: [ trachelCanvas := RWTRCanvas new engine: engine ].
	