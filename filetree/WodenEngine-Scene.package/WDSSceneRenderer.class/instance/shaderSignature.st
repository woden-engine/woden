accessing
shaderSignature
	^ shaderSignature ifNil: [ shaderSignature := self shaderSignatureClass for: engine ]