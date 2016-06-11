printing
printOn: aStream
	aStream nextPutAll: 'WTLightSourceData new intensity: '; print: intensity; nextPutAll: ' positionOrDirection: '; print: positionOrDirection