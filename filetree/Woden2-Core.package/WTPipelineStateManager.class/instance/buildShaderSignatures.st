abstract gpu baking
buildShaderSignatures
	shaderSignatures valuesDo: [ :shaderSignature | self buildShaderSignature: shaderSignature ]