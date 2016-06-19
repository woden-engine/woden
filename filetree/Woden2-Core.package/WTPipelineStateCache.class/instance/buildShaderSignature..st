abstract gpu baking
buildShaderSignature: shaderSignature
	| device signatureBuilder bindingType |
	device := engine device.
	signatureBuilder := device createShaderSignatureBuilder.
	shaderSignature elements do: [ :el |
		el isBank ifTrue: [
			signatureBuilder beginBindingBank: el maxBindings.
			el elements do: [ :bankElement |
				bindingType := ShaderBindingTypeMap at: bankElement bindingType.
				signatureBuilder addBindingBankElement: bindingType bindingPointCount: bankElement bindingPoints. 
			]
		].
	
		el isConstants ifTrue: [ 
			1 to: el count do: [ :i | signatureBuilder addBindingConstant ]
		]
	].

	shaderSignature handle: signatureBuilder build