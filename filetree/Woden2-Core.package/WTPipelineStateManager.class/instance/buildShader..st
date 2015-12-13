abstract gpu baking
buildShader: shader
	| languageName languageId stageId shaderHandle device |
	device := engine device.
	shader handleSet: nil.
	shaderLanguageSearchOrder do: [ :nameIdPair |
		languageName := nameIdPair key.
		languageId := nameIdPair value.
		shader implementations at: languageName ifPresent: [ :impl |
			shader handleSet: OrderedCollection new.
			impl stages keysAndValuesDo: [ :stageName :sourceCode |
				stageId := StageNameMap at: stageName.
				shaderHandle := device createShader: stageId.
				shaderHandle setShaderSource: languageId sourceText: sourceCode sourceTextLength: sourceCode size.
				shaderHandle compileShader: ''.
				shader handleSet add: shaderHandle
			].
			^ self.
		]
	].

	self error: 'Not valid implementation for shader "', shader name , '" was found.'