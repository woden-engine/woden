compiling
compile
	| newHandle oldHandle |
	newHandle := engine device createShader: stage.
	newHandle setShaderSource: shaderLanguageTarget sourceText: source source sourceTextLength: source source size.
	newHandle compileShader: ''.

	oldHandle := handle.
	handle := newHandle.
	
	oldHandle release.