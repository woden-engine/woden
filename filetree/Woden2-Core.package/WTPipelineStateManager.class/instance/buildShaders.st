abstract gpu baking
buildShaders
	| device |
	device := engine device.
	shaderLanguageSearchOrder := { device getPreferredShaderLanguage . device getPreferredHighLevelShaderLanguage} collect: [ :languageId | (ShaderLanguageNameMap at: languageId) -> languageId  ].
	shaders valuesDo: [ :shader | self buildShader: shader ]