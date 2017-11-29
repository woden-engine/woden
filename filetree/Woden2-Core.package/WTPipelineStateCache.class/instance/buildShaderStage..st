abstract gpu baking
buildShaderStage: stage
	| languageName languageId stageId device shaderHandle code |
	device := engine device.
	shaderLanguageSearchOrder do: [ :nameIdPair |
		languageName := nameIdPair key.
		languageId := nameIdPair value.
		stage implementations at: languageName ifPresent: [ :implementation |
			stageId := StageNameMap at: stage name.
			code := implementation readStreamDo: [:in | in binary. in contents ].
			shaderHandle := device createShader: stageId.
			shaderHandle setShaderSource: languageId sourceText: code sourceTextLength: code size.
			shaderHandle compileShader: ''.
			^ shaderHandle
		]
	].

	self error: 'Failed to find implementation for shader stage.'