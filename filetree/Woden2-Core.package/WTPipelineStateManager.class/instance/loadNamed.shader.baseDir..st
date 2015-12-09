state loading
loadNamed: shaderName shader: shaderDesc baseDir: baseDir
	| shader implementation sourceCode |
	shader := WTShader new
		name: shaderName asSymbol;
		yourself.
		
	shaderDesc keysAndValuesDo: [ :languageName :implDesc |
		implementation := WTShaderImplementation new.
		implDesc keysAndValuesDo: [ :stage :sourceFileName |
			sourceCode := (baseDir / sourceFileName) binaryReadStreamDo: [ :in | in contents ].
			implementation addStage: stage asSymbol code: sourceCode.
		].
		
		shader addLanguage: languageName asSymbol implementation: implementation
	].

	shaders at: shader name put: shader