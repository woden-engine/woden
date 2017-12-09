shaders
performShaderLoading: shaderFile stage: stageIdentifier
	| source stage |
	source := self loadLowLevelShaderCode: shaderFile.

	stage := WDCShaderStage new
		engine: engine;
		stage: stageIdentifier;
		shaderLanguageTarget: shaderLanguageTarget;
		source: source;
		yourself.
	stage compile.
	
	source addStage: stage.
	^ stage