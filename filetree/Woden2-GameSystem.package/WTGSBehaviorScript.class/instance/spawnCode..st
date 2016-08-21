accessing
spawnCode: aSourceCode
	spawnMethod := self class compileScript: aSourceCode. 
	spawnCode := aSourceCode.