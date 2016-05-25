state loading
loadNamed: shaderName shader: shaderDesc baseDir: baseDir
	| shader stage |
	shader := WTShader new
		name: shaderName asSymbol;
		yourself.

	shaderDesc keysAndValuesDo: [ :stageName :implementationsDesc |
		stage := WTShaderStage new name: stageName asSymbol.
		implementationsDesc keysAndValuesDo: [ :languageName :sourceFileName |
			stage addImplementation: languageName asSymbol fileReference:  baseDir / sourceFileName
		].
		
		shader addStage: stage
	].

	shaders at: shader name put: shader