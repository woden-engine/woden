abstract gpu baking
buildShaderSignature: shaderSignature
	| device signatureBuilder bindingType |
	device := engine device.
	signatureBuilder := device createShaderSignatureBuilder.
	shaderSignature elements do: [ :el |
		el isBank ifTrue: [
			bindingType := ShaderBindingTypeMap at: el bindingType.
			signatureBuilder addBindingBank: bindingType bindingPointCount: el bindingPoints maxBindings: el maxBindings
		]
	].

	shaderSignature handle: signatureBuilder build