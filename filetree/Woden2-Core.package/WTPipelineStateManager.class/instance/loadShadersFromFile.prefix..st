state loading
loadShadersFromFile: aFileName prefix: aShaderNamePrefix
	| shadersJson baseDir |
	baseDir := aFileName asFileReference parent.
	shadersJson := self readJsonFromFile: aFileName.
	shadersJson at: 'shaders' ifPresent: [ :shaderDescs |
		shaderDescs keysAndValuesDo: [ :name :shaderDesc |
			self loadNamed: (aShaderNamePrefix , name) asSymbol shader: shaderDesc baseDir: baseDir
		]
	].

	shadersJson at: 'groups' ifPresent: [ :groups |
		groups keysAndValuesDo: [ :newPrefix :fileName |
			self loadShadersFromFile: baseDir / fileName prefix: aShaderNamePrefix , newPrefix , '.'
		]
	]