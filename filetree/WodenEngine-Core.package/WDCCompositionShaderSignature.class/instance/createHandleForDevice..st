generated shader signature methods
createHandleForDevice: device
	^ device createShaderSignatureBuilder

		"Parameters"
		beginBindingBank: 1000;
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_UNIFORM_BUFFER bindingPointCount: 1; "Parameters"

		"Source"
		beginBindingBank: 1000;
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLED_IMAGE bindingPointCount: 1; "Texture"

		"Sampler"
		beginBindingBank: 10;
			addBindingBankElement: AGPU_SHADER_BINDING_TYPE_SAMPLER bindingPointCount: 1; "Sampler"

		build
