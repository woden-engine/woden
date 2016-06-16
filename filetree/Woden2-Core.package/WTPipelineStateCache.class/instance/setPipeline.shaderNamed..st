pipeline state object building
setPipeline: builder shaderNamed: shaderName
	| shader |
	shader := shaders at: shaderName asSymbol ifAbsent: [ 
		self error: 'Unknown shader ', shaders printString.
	].

	shader handleSet do: [ :handle |
		builder attachShader: handle
	].