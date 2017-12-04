initialization
createSamplers
	| samplerDesc |
	samplerDesc := AGPUSamplerDescription new
		filter: AGPU_FILTER_MIN_LINEAR_MAG_LINEAR_MIPMAP_LINEAR;
		address_u: AGPU_TEXTURE_ADDRESS_MODE_WRAP;
		address_v: AGPU_TEXTURE_ADDRESS_MODE_WRAP;
		address_w: AGPU_TEXTURE_ADDRESS_MODE_WRAP;
		max_lod: 10000.0;
		yourself.
		
	samplerBindings := self shaderSignature newSamplers.
	samplerBindings
		createSampler: 0 description: samplerDesc;
		createSampler: 1 description: samplerDesc.
		
	samplerDesc := AGPUSamplerDescription new
		filter: AGPU_FILTER_MIN_LINEAR_MAG_LINEAR_MIPMAP_LINEAR;
		address_u: AGPU_TEXTURE_ADDRESS_MODE_CLAMP ;
		address_v: AGPU_TEXTURE_ADDRESS_MODE_CLAMP;
		address_w: AGPU_TEXTURE_ADDRESS_MODE_CLAMP;
		max_lod: 10000.0;
		yourself.
	samplerBindings
		createSampler: 2 description: samplerDesc.