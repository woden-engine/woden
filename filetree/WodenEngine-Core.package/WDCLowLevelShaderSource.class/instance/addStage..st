initialization
addStage: aWDCShaderStage
	stagesMutex critical: [ 
		stages add: aWDCShaderStage
	]
