accessing
getOrCreateShaderSignature: aShaderSignatureClass
	| instance |
	^ shaderSignatures at: aShaderSignatureClass ifAbsentPut: [
		instance := aShaderSignatureClass new engine: engine.
		instance handle: (instance createHandleForDevice: engine device).
		instance
	]