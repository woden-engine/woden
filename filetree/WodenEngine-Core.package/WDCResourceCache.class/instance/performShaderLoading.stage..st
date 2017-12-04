shaders
performShaderLoading: shaderFile stage: stageIdentifier
	| source shaderHandle stage |
	source := self loadLowLevelShaderCode: shaderFile.

	shaderHandle := engine device createShader: stageIdentifier.
	shaderHandle setShaderSource: shaderLanguageTarget sourceText: source source sourceTextLength: source source size.
	shaderHandle compileShader: ''.

	stage := WDCShaderStage new source: source; handle: shaderHandle; yourself.
	^ stage