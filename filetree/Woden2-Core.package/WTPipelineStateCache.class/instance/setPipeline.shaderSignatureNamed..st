pipeline state object building
setPipeline: builder shaderSignatureNamed: shaderSignatureName
	| shaderSignature |
	shaderSignature  := shaderSignatures at: shaderSignatureName asSymbol ifAbsent: [ 
		self error: 'Unknown shader signature ' , shaderSignatureName printString
	].

	builder setShaderSignature: shaderSignature handle