viewport composition
shaderSignature
	^ shaderSignature ifNil: [ shaderSignature := WDCCompositionShaderSignature for: engine ]