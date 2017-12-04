comparing
hash
	| result |
	result := self class identityHash.
	result := result bitXor: vertexShader identityHash.
	result := result bitXor: vertexLayout identityHash.
	result := result bitXor: fragmentShader identityHash.
	result := result bitXor: shaderSignature identityHash.

	result := result bitXor: primitiveType hash.
	result := result bitXor: frontFaceWinding hash.
	result := result bitXor: cullMode hash.

	result := result bitXor: depthEnabled hash.
	result := result bitXor: depthWriteMask hash.
	result := result bitXor: depthFunction hash.

	result := result bitXor: renderTargetFormats hash.
	result := result bitXor: depthStencilFormat hash.
	result := result bitXor: blendingStates hash.
	result := result bitXor: sampleCount hash.

	^ result